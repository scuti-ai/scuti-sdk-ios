//
//  ScutiSDKManager.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 14/09/2023.
//

import Foundation
import WebKit
import SwiftUI
class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
@objc public class ScutiSDKManager: NSObject {
    @objc public static let shared = ScutiSDKManager()

    @objc public var delegate: ScutiSDKManagerDelegate?
    
    var targetEnvironment: TargetEnvironment = .development
    var appId: String = ""
    public var scutiWebview : WKWebView

    @ObservedObject public var scutiEvents = ScutiModel()
    @objc public var scutiEventsObjC = ScutiModelObjC()
    
    var showingScutiWebViewController: UIViewController?
    
    private var urlToRedirectAfterReady: URL?

    override init() {
        let configuration = WKWebViewConfiguration()
//        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.preferredContentMode = .recommended;
        configuration.processPool = WKProcessPool()
        configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")

//        configuration.allowsAirPlayForMediaPlayback = true
//        configuration.allowsPictureInPictureMediaPlayback = true

        scutiWebview = FullScreenWKWebView(frame: UIScreen.main.bounds, configuration: configuration)

        scutiWebview.translatesAutoresizingMaskIntoConstraints = false
        scutiWebview.allowsLinkPreview = true
        scutiWebview.allowsBackForwardNavigationGestures = true

        scutiWebview.isHidden = true
  
        scutiWebview.scrollView.contentInsetAdjustmentBehavior = .never
    }
    @objc public func initializeSDK(environment: TargetEnvironment, appId: String) throws {
        scutiWebview.navigationDelegate = self
        if !self.appId.isEmpty {
            throw ScutiError.alreadyInitialized
        }
        if appId.isEmpty {
            throw ScutiError.invalidAppId
        }
        targetEnvironment = environment
        self.appId = appId
        
        if let scutiToken = UserDefaults.standard.string(forKey: "scuti_token") {
            scutiEvents.userToken = scutiToken
            scutiEventsObjC.userToken = scutiToken
        }
        loadWebViewData()
    }
    private func loadWebViewData() {
        let url = targetEnvironment.url(id: appId, scutiToken: scutiEvents.userToken)
        let request = URLRequest(url: url)
        scutiWebview.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scutiWebview.frame = UIScreen.main.bounds
            if  let window = UIApplication.shared.firstKeyWindow {
                window.addSubview(self.scutiWebview)
            }
        }
    }
    @objc public func showScutiWebView(viewController: UIViewController) {
        if showingScutiWebViewController != nil {
            return
        }
        toggleStore(true)
        scutiWebview.removeFromSuperview()
        scutiWebview.isHidden = false
        showingScutiWebViewController = ScutiWebView()
        showingScutiWebViewController?.modalPresentationStyle = .fullScreen
        viewController.present(showingScutiWebViewController!, animated: false)
    }
    @objc public func redirectToUrl(url: URL) {
        if scutiEvents.isStoreReady {
            openUrl(url: url)
        } else {
            urlToRedirectAfterReady = url
        }
    }
    
    private func openUrl(url: URL) {
        let request = URLRequest(url: url)
        scutiWebview.load(request)
    }
}
extension ScutiSDKManager : WKNavigationDelegate, WKScriptMessageHandlerWithReply {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let js = "window.Unity = { call: function(msg) { window.location = 'unity:' + msg; }  };";
        webView.evaluateJavaScript(js)

    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let fullPath = url.absoluteString
            if fullPath.contains("//itunes.apple.com/") {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            } else if fullPath.starts(with: "unity:") {
                messageFromJS(webView:webView, message: fullPath.replacingOccurrences(of: "unity:", with: ""))
                decisionHandler(.cancel)
                return
            } else if !fullPath.starts(with: "about:blank") && !fullPath.starts(with: "file:") && !fullPath.starts(with: "http:") && !fullPath.starts(with: "https:") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
                return
            } else if navigationAction.navigationType == .linkActivated && (navigationAction.targetFrame != nil || !navigationAction.targetFrame!.isMainFrame) {
                webView.load(navigationAction.request)
                decisionHandler(.cancel)
                return
            } else if let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame {
                
            }
        }
        decisionHandler(.allow)
    }
    private func messageFromJS(webView:WKWebView, message:String)
    {
        let encoded = message.removingPercentEncoding!;
        let data = encoded.data(using: .utf8)!
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionary = jsonData as? [String: Any] else {
            return
        }
        guard let msg = dictionary["message"] as? String else {
            return
        }
        switch(msg)
        {
        case ScutiStoreMessage.USER_TOKEN.rawValue:
            if let token = dictionary["payload"] as? String {
                let defaults = UserDefaults.standard
                defaults.set(token, forKey:"scuti_token")
                defaults.synchronize()
                scutiEvents.userToken = token
                scutiEventsObjC.userToken = token
                delegate?.onUserToken(userToken: token)
                getNewProductsCommand();
                getNewRewardsCommand();
            }
            break;
        case ScutiStoreMessage.LOG_OUT.rawValue:
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "scuti_token")
            defaults.synchronize()
            scutiEvents.userToken = nil
            scutiEventsObjC.userToken = nil
            delegate?.onLogout()
            break;
        case ScutiStoreMessage.SCUTI_EXCHANGE.rawValue:
            if let payload = dictionary["payload"] as? [String : Any] {
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
                    let exchange = try JSONDecoder().decode(ScutiExchangeModel.self, from: jsonData)
                    scutiEvents.exchange = exchange
                    scutiEventsObjC.exchange = exchange.convertToClass()
                    delegate?.onScutiExchange(exchange: exchange.convertToClass())
                } catch {
                }
            }
            break
        case ScutiStoreMessage.NEW_PRODUCTS.rawValue:
            if let payload = dictionary["payload"] as? Int {
                scutiEvents.cntNewProducts = payload
                scutiEventsObjC.cntNewProducts = payload
                delegate?.onNewProducts(cntProducts: payload)
            }
            break
        case ScutiStoreMessage.NEW_REWARDS.rawValue:
            if let payload = dictionary["payload"] as? Int {
                scutiEvents.cntRewards = payload
                scutiEventsObjC.cntRewards = payload
                delegate?.onNewRewards(cntRewards: payload)
            }
            break
        case ScutiStoreMessage.BACK_TO_THE_GAME.rawValue:
            scutiEvents.backToGame = true
            scutiEventsObjC.backToGame = true
            delegate?.onBackToGame()
            showingScutiWebViewController?.dismiss(animated: true, completion: {
                self.toggleStore(false)
                self.showingScutiWebViewController = nil
            })
            break
        case ScutiStoreMessage.STORE_IS_READY.rawValue:
            startSession()
            getNewProductsCommand()
            getNewRewardsCommand()
            scutiEvents.isStoreReady = true
            scutiEventsObjC.isStoreReady = true
            delegate?.onStoreReady()
            break
        default:
            break
        }
    }

}
/// Commands to send to WebView
extension ScutiSDKManager {
    private func getNewProductsCommand()
    {
        scutiWebview.evaluateJavaScript("getNewProducts();")
    }
    
    private func getNewRewardsCommand()
    {
        scutiWebview.evaluateJavaScript("getNewRewards();")
    }

    public func toggleStore(_ value: Bool)
    {
        scutiWebview.evaluateJavaScript("toggleStore(\(value));")
    }

    public func setGameUserId(_ userId: String)
    {
        scutiWebview.evaluateJavaScript("setGameUserId(\(userId));")
    }

    public func startSession()
    {
        scutiWebview.evaluateJavaScript("startSession();")
    }

    public func endSession()
    {
        scutiWebview.evaluateJavaScript("endSession();")
    }

    public func hideBackToTheGame()
    {
        scutiWebview.evaluateJavaScript("hideBackToTheGame();")
        if let urlToRedirectAfterReady = urlToRedirectAfterReady {
            openUrl(url: urlToRedirectAfterReady)
        }
    }

}
