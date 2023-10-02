//
//  CustomView.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 28/09/2023.
//

import SwiftUI
import ScutiSDKSwift
import Combine

struct CustomView: View {
    @EnvironmentObject var scutiEvents: ScutiModel

    @State private var showModal = false
    private var debouncedPublisherBackToGame: AnyPublisher<Bool, Never>

    init() {
        debouncedPublisherBackToGame = ScutiSDKManager.shared.scutiEvents.$backToGame
                    .debounce(for: 0.1, scheduler: RunLoop.main)
                    .eraseToAnyPublisher()

    }
    var body: some View {
        VStack(alignment: .center) {
            Text("Store Ready : \(scutiEvents.isStoreReady ? "ON" : "OFF")").foregroundColor(scutiEvents.isStoreReady ? Color.green : Color.red)
                .padding()
            Text("User authenticated :  \(scutiEvents.userToken != nil ? "YES" : "NO")").foregroundColor(scutiEvents.userToken != nil ? Color.green : Color.red)
                .padding()
            Text("New Products : \(scutiEvents.cntNewProducts)").foregroundColor(.blue)
                .padding()
            Text("New Rewards : \(scutiEvents.cntRewards)").foregroundColor(.green)
                .padding()
            ZStack(alignment: .topLeading) {
                Image(uiImage: UIImage(named: "button")!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.leading, 20)
                    .onTapGesture {
                        showModal.toggle()
                        ScutiSDKManager.shared.toggleStore(showModal)
                    }
                    .fullScreenCover(isPresented: $showModal, onDismiss: {
                        ScutiSDKManager.shared.toggleStore(false)
                    }) {
                        ScutiWebViewSwiftUI()
                    }
                    .onReceive(debouncedPublisherBackToGame) { value in
                        showModal = false
                    }
                HStack {
                    Text("New: \(scutiEvents.cntNewProducts)")
                        .foregroundColor(.green)
                        .opacity(scutiEvents.cntNewProducts > 1 ? 1 : 0)
                    Spacer()
                    ZStack {
                        Text("\(scutiEvents.cntRewards)")
                            .foregroundColor(.blue)
                        Text("\(scutiEvents.cntRewards)")
                            .foregroundColor(.white)
                    }
                    .opacity(scutiEvents.cntRewards > 1 ? 1 : 0)
                }
            }
            .padding(.leading, 50)
        }
    }
}

