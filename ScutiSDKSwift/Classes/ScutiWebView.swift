//
//  ScutiWebView.swift
//  ScutiSDKSwift
//
//  Created by mac on 14/09/2023.
//

import SwiftUI
import WebKit
import UIKit

struct ScutiWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    var scutiWebview : WKWebView

    func makeUIView(context: Context) -> WKWebView {
//        let userContentController = ScutiSDKManager.shared.scutiWebview
//            .configuration
//            .userContentController
//
//        userContentController.removeAllScriptMessageHandlers()
//
//        userContentController.add(context.coordinator,
//                                  name: "fromWebPage")
//
//        userContentController.addScriptMessageHandler(context.coordinator,
//                                                      contentWorld: WKContentWorld.page,
//                                                      name: "getData")
//        ScutiSDKManager.shared.scutiWebview.uiDelegate = context.coordinator
        return scutiWebview
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

}

//extension ScutiWebView {
//    class Coordinator: NSObject, WKUIDelegate, WKScriptMessageHandler, WKScriptMessageHandlerWithReply {
//
//
//        func webView(_ webView: WKWebView,
//                     runJavaScriptAlertPanelWithMessage message: String,
//                     initiatedByFrame frame: WKFrameInfo,
//                     completionHandler: @escaping () -> Void) {
//            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& runJavaScriptAlertPanelWithMessage \(message)")
////            viewModel.webPanel(message: message,
////                               alertCompletionHandler: completionHandler)
//        }
//
//        func webView(_ webView: WKWebView,
//                     runJavaScriptConfirmPanelWithMessage message: String,
//                     initiatedByFrame frame: WKFrameInfo,
//                     completionHandler: @escaping (Bool) -> Void) {
////            viewModel.webPanel(message: message,
////                               confirmCompletionHandler: completionHandler)
//            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& runJavaScriptConfirmPanelWithMessage \(message)")
//        }
//
//        func webView(_ webView: WKWebView,
//                     runJavaScriptTextInputPanelWithPrompt prompt: String,
//                     defaultText: String?,
//                     initiatedByFrame frame: WKFrameInfo,
//                     completionHandler: @escaping (String?) -> Void) {
////            viewModel.webPanel(message: prompt,
////                               promptCompletionHandler: completionHandler,
////                               defaultText: defaultText)
//            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& runJavaScriptTextInputPanelWithPrompt \(prompt), defaultText: \(defaultText)")
//        }
//
//        // MARK: - WKScriptMessageHandler delegate function
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
////            self.viewModel.messageFrom(fromHandler: message.name,
////                                       message: message.body)
//            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& didReceive \(message.name),")
//        }
//
//        func userContentController(_ userContentController: WKUserContentController,
//                                   didReceive message: WKScriptMessage,
//                                   replyHandler: @escaping (Any?, String?) -> Void) {
//            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& didReceive replyHandler \(message.name),")
////            do {
////                let returnValue = try self.viewModel.messageFromWithReply(fromHandler: message.name,
////                                                                          message: message.body)
////
////                replyHandler(returnValue, nil)
////            } catch WebViewErrors.GenericError {
////                replyHandler(nil, "A generic error")
////            } catch WebViewErrors.ErrorWithValue(let value) {
////                replyHandler(nil, "Error with value: \(value)")
////            } catch {
////                replyHandler(nil, error.localizedDescription)
////            }
//        }
//    }
//}
struct ScutiWebView_Previews: PreviewProvider {
    static var previews: some View {
        ScutiWebView(scutiWebview: ScutiSDKManager.shared.scutiWebview)
    }
}
