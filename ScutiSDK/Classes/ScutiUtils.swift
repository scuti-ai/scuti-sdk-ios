//
//  ScutiUtils.swift
//  
//
//  Created by Mark Grossnickle on 5/2/23.
//

import Foundation


public enum TargetEnvironment
{
    case Development
    case Staging
    case Production
}

class ScutiUtils
{
    static func GetURL(id:String, target: TargetEnvironment ) -> URL
    {
        var result:String; 
        switch (target)
        {
        case TargetEnvironment.Development:
            result = "https://dev.run.app.scuti.store/?gameId=\(id)&platform=Unity";
        case TargetEnvironment.Staging:
            result =  "https://staging.run.app.scuti.store/?gameId=\(id)&platform=Unity";
        case TargetEnvironment.Production:
            result = "https://store.scutishopping.com/?gameId=\(id)&platform=Unity";
        }
        let defaults = UserDefaults.standard
        if let scutiToken = defaults.string(
            forKey: "scuti_token"
        ) {
            result = result+"&token="+scutiToken;
        }
        
        return URL(string: result)!;
    }
}
