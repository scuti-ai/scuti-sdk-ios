//
//  Enum.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 14/09/2023.
//

import Foundation
import UIKit

public enum ScutiStoreMessage: String {
    case BACK_TO_THE_GAME
    case SCUTI_EXCHANGE
    case NEW_REWARDS
    case NEW_PRODUCTS
    case USER_TOKEN
    case STORE_IS_READY
    case LOG_OUT
}

@objc public enum TargetEnvironment: Int {
    case development
    case staging
    case production
}
extension TargetEnvironment {
    public func url(id: String, scutiToken: String?) -> URL
    {
        var result:String;
        switch (self)
        {
        case TargetEnvironment.development:
            result = "https://dev.run.app.scuti.store/?gameId=\(id)&platform=Unity"
        case TargetEnvironment.staging:
            result =  "https://staging.run.app.scuti.store/?gameId=\(id)&platform=Unity"
        case TargetEnvironment.production:
            result = "https://store.scutishopping.com/?gameId=\(id)&platform=Unity"
        }
        let defaults = UserDefaults.standard
        if let scutiToken = defaults.string(forKey: "scuti_token") {
            result = "\(result)&token=\(scutiToken)"
        }
        
        return URL(string: result)!;
    }
}

public enum ScutiError: Error {
    case alreadyInitialized
    case invalidAppId
}

public enum ScutiIcons: String {
    
    case newReward = "navstepperinactive"
    case newItem = "new_items_flag"
    case logo = "scuti_logo_white"
    
    /// Returns the associated image.
    public var image: UIImage {
        return UIImage(named: rawValue, in: Bundle.scutiFrameworkBundle(), compatibleWith: nil)!//.withRenderingMode(.alwaysTemplate)
    }
}

extension Bundle {
    static func scutiFrameworkBundle() -> Bundle {
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleToken.self).resourceURL,
            Bundle.main.bundleURL,
        ]
        let bundleNames = [
            "ScutiSDKSwift_ScutiSDKSwift",
            "ScutiSDKSwift",
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }

        return Bundle(for: BundleToken.self)
    }
}
private class BundleToken {}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
