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
        
    }

    public func makeUIViewController(context: Context) -> ScutiWebView {
        return ScutiWebView()
    }

    public func updateUIViewController(_ uiViewController: ScutiWebView, context: Context) {
    }
}


public struct ScutiWebViewSwiftUI_Previews: PreviewProvider {
    public static var previews: some View {
        ScutiWebViewSwiftUI()
    }
}
