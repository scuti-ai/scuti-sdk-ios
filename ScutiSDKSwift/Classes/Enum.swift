//
//  Enum.swift
//  ScutiSDKSwift
//
//  Created by mac on 14/09/2023.
//

import Foundation

public enum ScutiStoreMessage: String {
    case BACK_TO_THE_GAME
    case SCUTI_EXCHANGE
    case NEW_REWARDS
    case NEW_PRODUCTS
    case USER_TOKEN
    case STORE_IS_READY
    case LOG_OUT
}

public enum TargetEnvironment {
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
