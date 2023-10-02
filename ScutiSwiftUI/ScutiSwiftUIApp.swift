//
//  ScutiSwiftUIApp.swift
//  ScutiSwiftUI
//
//  Created by Adrian R on 12/09/2023.
//

import SwiftUI
import ScutiSDKSwift

@main
struct ScutiSwiftUIApp: App {
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
//                try ScutiSDKManager.shared.initializeSDK(environment: .production, appId: "6db28ef4-69b0-421a-9344-31318f898790")
                try ScutiSDKManager.shared.initializeSDK(environment: .development, appId: "1e6e003f-0b94-4671-bc35-ccc1b48ce87d")
            } catch {
                print("initializeSDK ex : \(error)")
            }
        }
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}

