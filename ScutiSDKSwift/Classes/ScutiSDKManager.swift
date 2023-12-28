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
    @objc public var logDelegate: ScutiSDKManagerLogDelegate?
    
    public var targetEnvironment: TargetEnvironment = .development
    public var appId: String = ""
    public var needRedirect: Bool = false
    public var scutiWebview : WKWebView = WKWebView()

    @ObservedObject public var scutiEvents = ScutiModel()
    @objc public var scutiEventsObjC = ScutiModelObjC()
    
    var showingScutiWebViewController: UIViewController?
    
    private var urlToRedirectAfterReady: URL?

    override init() {
    }
    @objc public func initializeSDK(environment: TargetEnvironment, appId: String) throws {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "unityControl")
        let script = WKUserScript(source: """
        (function() { \
            var meta = document.querySelector('meta[name=viewport]'); \
            if (meta == null) { \
                meta = document.createElement('meta'); \
                meta.name = 'viewport'; \
            } \
            meta.content += ((meta.content.length > 0) ? ',' : '') + 'user-scalable=no'; \
            var head = document.getElementsByTagName('head')[0]; \
            head.appendChild(meta); \
        })(); 
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        let script = WKUserScript(source: """
//        (function() {
//            var meta = document.querySelector('meta[name=viewport]');
//            if (meta == null) {
//                meta = document.createElement('meta');
//                meta.name = 'viewport';
//            }
//            meta.content += ((meta.content.length > 0) ? ',' : '') + 'user-scalable=no';
//            var head = document.getElementsByTagName('head')[0];
//            head.appendChild(meta);
//        })();
//        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        configuration.userContentController = userContentController

        
//        configuration.defaultWebpagePreferences.allowsContentJavaScript = false
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.preferredContentMode = .recommended;
//        configuration.processPool = WKProcessPool()
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
        scutiWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        scutiWebview.navigationDelegate = self
        scutiWebview.uiDelegate = self
        

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
            showingScutiWebViewController?.dismiss(animated: false)
            showingScutiWebViewController = nil
        }
        toggleStore(true)
        scutiWebview.removeFromSuperview()
        scutiWebview.isHidden = false
        showingScutiWebViewController = ScutiWebView()
//        showingScutiWebViewController?.modalPresentationStyle = .fullScreen
        let navVC = ScutiNavigationController(rootViewController: showingScutiWebViewController!)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: false)
    }
    @objc public func redirectToUrl(url: URL) {
        if scutiEvents.isStoreReady {
            openUrl(url: url)
        } else {
            urlToRedirectAfterReady = url
        }
    }
    
    private func openUrl(url: URL) {
        var newUrl = url
        var fullPath = url.absoluteString
        if fullPath.contains("product-offer"), !fullPath.contains("?gameId=") {
            if #available(iOS 16.0, *) {
                newUrl.append(queryItems: [URLQueryItem(name: "gameId", value: appId)])
            } else {
                if fullPath.contains("?") {
                    fullPath = "\(fullPath)&gameId=\(appId)"
                } else {
                    fullPath = "\(fullPath)?gameId=\(appId)"
                }
                if let url = URL(string: fullPath) {
                    newUrl = url
                }
            }
        }
        let request = URLRequest(url: newUrl)
        scutiWebview.load(request)
    }
}
extension ScutiSDKManager : WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("======== userContentController : \(message.body)")
        if let strMessage = message.body as? String {
            messageFromJS(message: strMessage)
        }
    }
    
//    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
//        print("======== userContentController : \(message.body)")
//    }
//    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
//        
//    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let js = "window.Unity = { call: function(msg) { window.location = 'unity:' + msg; }  };";
//        let js = """
//        (function() {
//            var meta = document.querySelector('meta[name=viewport]');
//            if (meta == null) {
//                meta = document.createElement('meta');
//                meta.name = 'viewport';
//            }
//            meta.content += ((meta.content.length > 0) ? ',' : '') + 'user-scalable=no';
//            var head = document.getElementsByTagName('head')[0];
//            head.appendChild(meta);
//        })();
//        """
//                let js = """
//        if (window && window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.unityControl) {
//             window.Unity = {
//                 call: function(msg) {
//                     window.webkit.messageHandlers.unityControl.postMessage(msg);
//                 }
//             }
//         } else {
//             window.Unity = {
//                 call: function(msg) {
//                     window.location = 'unity:' + msg;
//                 }
//             }
//         }
//        """;
        webView.evaluateJavaScript(js) { res, error in
            print("evaluateJavaScript : \(res)  : \(error)")
        }

    }
//    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        print("======== userContentController  createWebViewWith : \(navigationAction.request)")
//        if (!(navigationAction.targetFrame?.isMainFrame ?? false)) {
//            webView.load(navigationAction.request)
//        }
//        return nil
//    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let fullPath = url.absoluteString
            logDelegate?.onLog(log: "=======<\(navigationAction.navigationType.rawValue) : \(navigationAction.targetFrame?.isMainFrame ?? false)>======= decidePolicyFor : \(fullPath)")
            if needRedirect, fullPath.contains(targetEnvironment.webLink()) && !fullPath.contains("gameId=") {
                decisionHandler(.cancel)
                let request = URLRequest(url: targetEnvironment.url(id: appId, scutiToken: scutiEvents.userToken))
                scutiWebview.load(request)
                needRedirect = false
                return
            } 
            needRedirect = false
            if fullPath.contains("//itunes.apple.com/") {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            } else if fullPath.starts(with: "unity:") {
                messageFromJS(message: fullPath.replacingOccurrences(of: "unity:", with: "").removingPercentEncoding!)
                decisionHandler(.cancel)
                return
            } else if !fullPath.starts(with: "about:blank") && !fullPath.starts(with: "file:") && !fullPath.starts(with: "http:") && !fullPath.starts(with: "https:") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
                return
            } else if fullPath.lowercased().contains("g.doubleclick"), fullPath.lowercased().contains("adurl=") {
                if let vc = scutiWebview.parentViewController {
                    let adsVC = ScutiAdsWebView()
                    if let navigationVC = vc.navigationController {
                        navigationVC.pushViewController(adsVC, animated: false)
                        adsVC.loadAds(url: url)
                    } else {
                        adsVC.modalPresentationStyle = .fullScreen
                        vc.present(adsVC, animated: false) {
                            adsVC.loadAds(url: url)
                        }
                    }
                } else if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
                return
            } else if navigationAction.navigationType == .linkActivated && !(navigationAction.targetFrame?.isMainFrame ?? false) {
                if let vc = scutiWebview.parentViewController {
                    let adsVC = ScutiAdsWebView()
                    if let navigationVC = vc.navigationController {
                        navigationVC.pushViewController(adsVC, animated: false)
                        adsVC.loadAds(url: url)
                    } else {
                        adsVC.modalPresentationStyle = .fullScreen
                        vc.present(adsVC, animated: false) {
                            adsVC.loadAds(url: url)
                        }
                    }
                } else if UIApplication.shared.canOpenURL(url) {
                    webView.load(navigationAction.request)
                }
                decisionHandler(.cancel)
                return
            } else if let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame {
                
            }
        }
        decisionHandler(.allow)
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        
        return .allow
    }
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        var disposition: URLSession.AuthChallengeDisposition?
//        var credential: URLCredential?
//        if (basicau)
        completionHandler(.performDefaultHandling, nil)
    }
    private func messageFromJS(message:String)
    {
        let data = message.data(using: .utf8)!
        
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
