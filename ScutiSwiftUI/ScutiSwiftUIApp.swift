//
//  ScutiSwiftUIApp.swift
//  ScutiSwiftUI
//
//  Created by mac on 12/09/2023.
//

import SwiftUI
import ScutiSDKSwift

@main
struct ScutiSwiftUIApp: App {
    init() {
        do {
            try ScutiSDKManager.shared.initializeSDK(environment: .production, appId: "6db28ef4-69b0-421a-9344-31318f898790")
        } catch {
            print("initializeSDK ex : \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
