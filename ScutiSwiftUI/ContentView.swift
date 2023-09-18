//
//  ContentView.swift
//  ScutiSwiftUI
//
//  Created by mac on 12/09/2023.
//

import SwiftUI
import ScutiSDKSwift

struct ContentView: View {
    @State private var txtStoreReady = "Store Ready : OFF"
    @State private var colorStoreReady = Color.red
    @State private var txtCntProducts = "New Products : 0"
    @State private var txtCntRewards = "New Rewards : 0"

    init() {
        ScutiSDKManager.shared.delegate = self
    }
    var body: some View {
        VStack {
            Text(txtStoreReady).foregroundColor(colorStoreReady)
            Text("New Products : 0").foregroundColor(.blue)
            Text("New Rewards : 0").foregroundColor(.green)
            ScutiButton()
                .frame(width: 260, height: 90)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView: ScutiSDKManagerDelegate {
    /// ///////////////////// Scuti SDK delegates
    func onStoreReady() {
        txtStoreReady = "Store Ready : ON"
        colorStoreReady = .green
    }
    func onNewProducts(cntProducts: Int) {
        txtCntProducts = "New Products : \(cntProducts)"
    }
    func onNewRewards(cntRewards: Int) {
        txtCntRewards = "New Rewards : \(cntRewards)"
    }
    func onBackToGame() {
        
    }
    func onUserToken(userToken: String) {
        
    }
    func onScutiExchange(exchange: ScutiExchangeModel) {
        
    }
    func onLogout() {
        
    }
    func onErrorOccurred(error: Error) {
        
    }

}
