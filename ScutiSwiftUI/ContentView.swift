//
//  ContentView.swift
//  ScutiSwiftUI
//
//  Created by mac on 12/09/2023.
//

import SwiftUI
import ScutiSDKSwift

struct ContentView: View, ScutiSDKManagerDelegate {
    @EnvironmentObject var scutiEvents: ScutiModel

    var body: some View {
        VStack {
            Text("Store Ready : \(scutiEvents.isStoreReady ? "On" : "Off")").foregroundColor(scutiEvents.isStoreReady ? Color.green : Color.red)
            Text("New Products : \(scutiEvents.cntNewProducts)").foregroundColor(.blue)
            Text("New Rewards : \(scutiEvents.cntRewards)").foregroundColor(.green)
            ScutiButton()
                .frame(width: 260, height: 90)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


