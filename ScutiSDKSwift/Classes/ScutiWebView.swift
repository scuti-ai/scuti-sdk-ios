//
//  ScutiWebView.swift
//  ScutiSDKSwift
//
//  Created by mac on 14/09/2023.
//

import SwiftUI
import WebKit

struct ScutiWebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        return ScutiSDKManager.shared.scutiWebview
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
    }
}

struct ScutiWebView_Previews: PreviewProvider {
    static var previews: some View {
        ScutiWebView()
    }
}
