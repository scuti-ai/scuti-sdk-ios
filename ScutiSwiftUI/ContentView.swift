//
//  ContentView.swift
//  ScutiSwiftUI
//
//  Created by mac on 12/09/2023.
//

import SwiftUI
import ScutiSDKSwift

struct ContentView: View {
    @EnvironmentObject var scutiEvents: ScutiModel

    var body: some View {
        NavigationStack {
             List {
                 NavigationLink("Normal Usage", destination: NormalView()
                    .environmentObject(ScutiSDKManager.shared.scutiEvents)
                    .navigationTitle("Normal Usage"))
                 NavigationLink("Custom Button Usage", destination: CustomView()
                    .environmentObject(ScutiSDKManager.shared.scutiEvents)
                    .navigationTitle("Custom Button Usage"))
             }
             .navigationTitle("Scuti Swift UI Example")
             .navigationBarTitleDisplayMode(.inline)
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


