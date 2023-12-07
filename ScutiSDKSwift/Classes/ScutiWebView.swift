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
        return true
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0546875, green: 0.046875, blue: 0.0625, alpha: 1)
        initilaizeUI()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
@objc public class ScutiNavigationController : UINavigationController {
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
extension ScutiNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
class ScutiAdsWebView: UIViewController {

    var webview : WKWebView = FullScreenWKWebView(frame: UIScreen.main.bounds)

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0546875, green: 0.046875, blue: 0.0625, alpha: 1)
        initilaizeUI()
    }
    
    func initilaizeUI() {
        webview.configuration.allowsInlineMediaPlayback = true
        webview.configuration.mediaTypesRequiringUserActionForPlayback = []
        webview.configuration.websiteDataStore = .default()
        webview.configuration.defaultWebpagePreferences.preferredContentMode = .recommended;
        webview.configuration.processPool = WKProcessPool()
        webview.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webview.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")

        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.allowsLinkPreview = true
        webview.allowsBackForwardNavigationGestures = true
  
        webview.scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(webview)
        

        let buttonRadius = 10.0

        let btn = UIButton(frame: .zero)
        btn.layer.cornerRadius = buttonRadius
        btn.backgroundColor = UIColor(red: 0.0546875, green: 0.046875, blue: 0.0625, alpha: 1)
        btn.layer.borderColor = UIColor(red: 0.1171875, green: 0.20703125, blue: 0.93359375, alpha: 1).cgColor
        btn.layer.borderWidth = 3
        btn.setImage(ScutiIcons.logo.image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
//        var configuration = UIButton.Configuration.plain()
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
//        btn.configuration = configuration
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)

        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            btn.widthAnchor.constraint(equalToConstant: 97),
            btn.heightAnchor.constraint(equalToConstant: 33),
        ])

        NSLayoutConstraint.activate([
            webview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webview.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 4),
            webview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
   }
    func loadAds(url: URL) {
        let request = URLRequest(url: url)
        webview.load(request)
    }
    @objc func buttonClicked() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: false)
        } else {
            dismiss(animated: false)
        }
    }
}
