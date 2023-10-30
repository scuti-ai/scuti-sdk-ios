//
//  ScutiWebView.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 14/09/2023.
//

//import SwiftUI
import WebKit
import UIKit

@objc public class ScutiWebView: UIViewController {
    public override var prefersStatusBarHidden: Bool {
        return ScutiSDKManager.shared.standalone
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initilaizeUI()
    }
    
    func initilaizeUI() {
        view.addSubview(ScutiSDKManager.shared.scutiWebview)
        
        NSLayoutConstraint.activate([
            ScutiSDKManager.shared.scutiWebview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            ScutiSDKManager.shared.scutiWebview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            ScutiSDKManager.shared.scutiWebview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            ScutiSDKManager.shared.scutiWebview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

    }
}
