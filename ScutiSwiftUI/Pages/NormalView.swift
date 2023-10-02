//
//  NormalView.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 28/09/2023.
//

import SwiftUI
import ScutiSDKSwift

struct NormalView: View {
    @EnvironmentObject var scutiEvents: ScutiModel

    var body: some View {
        VStack {
            Text("Store Ready : \(scutiEvents.isStoreReady ? "ON" : "OFF")").foregroundColor(scutiEvents.isStoreReady ? Color.green : Color.red)
                .padding()
            Text("User authenticated :  \(scutiEvents.userToken != nil ? "YES" : "NO")").foregroundColor(scutiEvents.userToken != nil ? Color.green : Color.red)
                .padding()
            Text("New Products : \(scutiEvents.cntNewProducts)").foregroundColor(.blue)
                .padding()
            Text("New Rewards : \(scutiEvents.cntRewards)").foregroundColor(.green)
                .padding()
            
            ScutiButtonSwiftUI()
                .frame(width: 260, height: 90)
        }
    }
}

