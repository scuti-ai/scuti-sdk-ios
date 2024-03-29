//
//  ScutiWebViewSwiftUI.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 28/09/2023.
//

import SwiftUI

public struct ScutiWebViewSwiftUI: UIViewControllerRepresentable {
    public typealias UIViewControllerType = ScutiWebView
    
    public init() {
        ScutiSDKManager.shared.scutiWebview.removeFromSuperview()
        ScutiSDKManager.shared.scutiWebview.isHidden = false
    }

    public func makeUIViewController(context: Context) -> ScutiWebView {
        return ScutiWebView()
    }

    public func updateUIViewController(_ uiViewController: ScutiWebView, context: Context) {
    }
}
