//
//  ScutiWebView.swift
//
//
//  Created by Mark Grossnickle on 5/2/23.
//

import Foundation
import WebKit
import SwiftUI

public struct ScutiWebView: UIViewRepresentable {
    
    
    @EnvironmentObject  var scutiEvents:ScutiModel;
    //@StateObject  var scutiEvents:ScutiModel = ScutiModel();
    var targetEnvironment:TargetEnvironment;
    var appId:String;
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.SetEvents(scutiEvents: scutiEvents);
        let url = ScutiUtils.GetURL(id:appId, target: targetEnvironment)
        let request = URLRequest(url: url)
        webView.load(request)
       // webView.isHidden = true;
        //context.coordinator.Hide();
        return webView
    }
    
    public init(environment:TargetEnvironment, id:String) {
        targetEnvironment = environment;
        appId = id;
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {}
    
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        
        
        var notifier:ScutiModel?;
        var _webView:WKWebView?;
        
       
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            _webView = webView;
            let js = "window.Unity = { call: function(msg) { window.location = 'unity:' + msg; }  };";
            webView.evaluateJavaScript(js)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let fullPath = navigationAction.request.url?.absoluteString;
            if fullPath != nil
            {
                if(fullPath!.starts(with: "unity:"))
                {
                    let index = fullPath!.index(fullPath!.startIndex, offsetBy:6);
                    MessageFromJS(webView:webView, message:String(fullPath![index...]));
                    decisionHandler(.cancel)
                    return;
                }
            }
            decisionHandler(.allow)
        }
        
        public func SetEvents(scutiEvents:ScutiModel)
        {
            notifier = scutiEvents;
        }
        
        public func MessageFromJS(webView:WKWebView, message:String)
        {
            let encoded = message.removingPercentEncoding!;
            print("full: "+encoded);
            let data = encoded.data(using: .utf8)!
            let JSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let dictionary = JSON as? [String: Any];
           // let dict = try? JSONDecoder().decode([String: Any].self, from: msg)
            let msg = dictionary!["message"] as! String;
            print("message: "+msg);
            switch(msg)
            {
            case "USER_TOKEN":
                let token = dictionary?["payload"]
                let defaults = UserDefaults.standard
                defaults.set(token, forKey:"scuti_token")
                break;
            case "LOG_OUT":
                break;
            case "SCUTI_EXCHANGE":
                let innerDict = dictionary?["payload"] as! [String : Any];
                notifier!.scutisExchanged = innerDict["currencyEarned"] as! Int;
                break;
                case "NEW_PRODUCTS":
               // _notifier.productCount;
                notifier!.productCount = dictionary?["payload"] as! Int;
                break;
                case "NEW_REWARDS":
                notifier!.rewardCount = dictionary?["payload"] as! Int;
                break;
                case "BACK_TO_THE_GAME":
                notifier!.exitRequest = true;
            case "STORE_IS_READY":
                GetNewProducts();
                GetNewRewards();
                break;
            default:
                print("Message from JS:" , msg);
            }
        }
        
        public func GetNewProducts()
        {
            _webView?.evaluateJavaScript("getNewProducts();");
        }
        
        public func GetNewRewards()
        {
            _webView?.evaluateJavaScript("getNewRewards();");
        }
        
        public func Show()
        {
             _webView?.evaluateJavaScript("toggleStore(true);")
            _webView?.isHidden = false;
        }
        
        public func Hide()
        {
             _webView?.evaluateJavaScript("toggleStore(false);")
            _webView?.isHidden = true;
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public var coordinator = Coordinator()
}


