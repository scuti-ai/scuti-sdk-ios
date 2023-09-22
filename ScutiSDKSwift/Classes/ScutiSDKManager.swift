//
//  ScutiSDKManager.swift
//  ScutiSDKSwift
//
//  Created by mac on 14/09/2023.
//

import Foundation
import WebKit
import SwiftUI

public class ScutiSDKManager: NSObject {
    public static let shared = ScutiSDKManager()

    public var delegate: ScutiSDKManagerDelegate?
    
    var targetEnvironment: TargetEnvironment = .development
    var appId: String = ""
    var scutiWebview : WKWebView

    @ObservedObject public var scutiEvents = ScutiModel()
    
    var showingScutiWebViewController: UIViewController?
    
    override init() {
        scutiWebview = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
//#if DEBUG
//        self.scutiWebview.isInspectable = true
//#endif

    }
    public func initializeSDK(environment: TargetEnvironment, appId: String) throws {
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
        }
        _ = Task {
            await self.loadWebViewData()
        }
    }
    func loadWebViewData() async {
//        try? await Task.sleep(nanoseconds: UInt64(0.5 * Double(NSEC_PER_SEC)))
        scutiWebview.navigationDelegate = self
        let url = targetEnvironment.url(id: appId, scutiToken: scutiEvents.userToken)
        let request = URLRequest(url: url)
        scutiWebview.load(request)
    }
    public func showScutiWebView(viewController: UIViewController) {
        if showingScutiWebViewController != nil {
            return
        }
        toggleStore(true)
        showingScutiWebViewController = UIHostingController(rootView: ScutiWebView(scutiWebview: scutiWebview))
        showingScutiWebViewController?.modalPresentationStyle = .fullScreen
        viewController.present(showingScutiWebViewController!, animated: true)
    }
}

extension ScutiSDKManager : WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("======== webView didFinish : \(webView.url?.absoluteString ?? "")")
        let js = "window.Unity = { call: function(msg) { window.location = 'unity:' + msg; }  };";
//        let js = """
//if (window && window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.unityControl) {
//     window.Unity = {
//         call: function(msg) {
//             window.webkit.messageHandlers.unityControl.postMessage(msg);
//         }
//     }
// } else {
//     window.Unity = {
//         call: function(msg) {
//             window.location = 'unity:' + msg;
//         }
//     }
// }
//""";
        webView.evaluateJavaScript(js)

    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("======== decidePolicyFor : \(navigationAction.request.url?.absoluteString ?? "")")
        if let fullPath = navigationAction.request.url?.absoluteString
        {
            if(fullPath.starts(with: "unity:"))
            {
                messageFromJS(webView:webView, message: fullPath.replacingOccurrences(of: "unity:", with: ""));
                decisionHandler(.cancel)
                return;
            }
        }
        decisionHandler(.allow)
    }
    private func messageFromJS(webView:WKWebView, message:String)
    {
        let encoded = message.removingPercentEncoding!;
        print("===== decidePolicyFor full: \(encoded)");
        let data = encoded.data(using: .utf8)!
        
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionary = jsonData as? [String: Any] else {
            return
        }
        guard let msg = dictionary["message"] as? String else {
            return
        }
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ message: \(msg) : \(dictionary["payload"] ?? "")");
        switch(msg)
        {
        case ScutiStoreMessage.USER_TOKEN.rawValue:
            if let token = dictionary["payload"] as? String {
                let defaults = UserDefaults.standard
                defaults.set(token, forKey:"scuti_token")
                defaults.synchronize()
                scutiEvents.userToken = token
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
            delegate?.onLogout()
            break;
        case ScutiStoreMessage.SCUTI_EXCHANGE.rawValue:
            if let payload = dictionary["payload"] as? [String : Any] {
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
                    let exchange = try JSONDecoder().decode(ScutiExchangeModel.self, from: jsonData)
                    scutiEvents.exchange = exchange
                    delegate?.onScutiExchange(exchange: exchange)
                } catch {
                    print("+++++++++ SCUTI_EXCHANGE error: \(error)");
                }
            }
            break;
        case ScutiStoreMessage.NEW_PRODUCTS.rawValue:
            if let payload = dictionary["payload"] as? Int {
                scutiEvents.cntNewProducts = payload
                delegate?.onNewProducts(cntProducts: payload)
            }
            break;
        case ScutiStoreMessage.NEW_REWARDS.rawValue:
            if let payload = dictionary["payload"] as? Int {
                scutiEvents.cntRewards = payload
                delegate?.onNewRewards(cntRewards: payload)
            }
            break;
        case ScutiStoreMessage.BACK_TO_THE_GAME.rawValue:
            scutiEvents.backToGame = true
            delegate?.onBackToGame()
            showingScutiWebViewController?.dismiss(animated: true, completion: {
                self.toggleStore(false)
                self.showingScutiWebViewController = nil
            })
            break;
        case ScutiStoreMessage.STORE_IS_READY.rawValue:
            startSession()
            getNewProductsCommand();
            getNewRewardsCommand();
            scutiEvents.isStoreReady = true
            delegate?.onStoreReady()
            break;
        default:
            print("Message from JS:" , msg);
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

    func toggleStore(_ value: Bool)
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

}
