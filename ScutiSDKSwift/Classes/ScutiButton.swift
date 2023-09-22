//
//  ScutiButton.swift
//  ScutiSDKSwift
//
//  Created by mac on 14/09/2023.
//

import SwiftUI
import Combine

public struct ScutiButton: View {
//    let appBundle = Bundle(identifier:"com.scuti.ScutiSDKSwift")
    let buttonRadius = 10.0
    
    @State private var showModal = false
    @State private var showNewItems = false
    @State private var showNewRewards = false

    private var debouncedPublisherNewItems: AnyPublisher<Int, Never>
    private var debouncedPublisherNewRewards: AnyPublisher<Int, Never>
    private var debouncedPublisherBackToGame: AnyPublisher<Bool, Never>

    public init() {
        debouncedPublisherNewItems = ScutiSDKManager.shared.scutiEvents.$cntNewProducts
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        debouncedPublisherNewRewards = ScutiSDKManager.shared.scutiEvents.$cntRewards
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        debouncedPublisherBackToGame = ScutiSDKManager.shared.scutiEvents.$backToGame
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    public var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: buttonRadius).foregroundColor(Color(UIColor(red: 0.0546875, green: 0.046875, blue: 0.0625, alpha: 1)))
                .overlay {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .stroke(style: StrokeStyle(lineWidth: 4)).foregroundColor(Color(UIColor(red: 0.1171875, green: 0.20703125, blue: 0.93359375, alpha: 1)))
                }
                .overlay {
                    Image(uiImage: ScutiIcons.logo.image)
                }
                .padding(.leading, 80)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .onTapGesture {
                    showModal.toggle()
                    ScutiSDKManager.shared.toggleStore(showModal)
                }
                .fullScreenCover(isPresented: $showModal, onDismiss: {
                    ScutiSDKManager.shared.toggleStore(false)
                }) {
                    ScutiWebView(scutiWebview: ScutiSDKManager.shared.scutiWebview)
                }
                .onReceive(debouncedPublisherBackToGame) { value in
                    showModal = false
                }
           HStack {
                Image(uiImage: ScutiIcons.newItem.image)
                    .resizable()
                    .frame(width: 94, height: 28)
                    .opacity(showNewItems ? 1 : 0)
                    .onReceive(debouncedPublisherNewItems) { value in
                        showNewItems = value > 0
                    }
                Spacer()
                ZStack {
                    Image(uiImage: ScutiIcons.newReward.image)
                        .resizable()
                    .frame(width: 30, height: 30)
                    Text("\(ScutiSDKManager.shared.scutiEvents.cntRewards)")
                        .foregroundColor(.white)
                }
                .opacity(showNewRewards ? 1 : 0)
                .onReceive(debouncedPublisherNewRewards) { value in
                    showNewRewards = value > 0
                }
            }
        }
        
    }
}

struct ScutiButton_Previews: PreviewProvider {
    static var previews: some View {
        ScutiButton()
    }
}
