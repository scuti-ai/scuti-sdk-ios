//
//  ScutiUtils.swift
//  
//
//  Created by Mark Grossnickle on 5/2/23.
//

import Foundation

public class ScutiModel: ObservableObject {
    @Published public var cntRewards: Int = 0
    @Published public var cntNewProducts: Int = 0
    @Published public var exchange: ScutiExchangeModel?
    @Published public var backToGame: Bool = false
    @Published public var isStoreReady: Bool = false
    @Published public var userToken: String?
    
    public init()
    {
    }
}

public struct ScutiExchangeModel: Decodable {
    public var id: String
    public var scutisSpent: Double
    public var currencyEarned: Double
    public var currencyName: String
}

public protocol ScutiSDKManagerDelegate {
    func onScutiButtonClicked()
    func onStoreReady()
    func onBackToGame()
    func onNewProducts(cntProducts: Int)
    func onNewRewards(cntRewards: Int)
    func onScutiExchange(exchange: ScutiExchangeModel)
    func onUserToken(userToken: String)
    func onLogout()

    func onErrorOccurred(error: Error)
}
public extension ScutiSDKManagerDelegate {
    func onScutiButtonClicked() {
        
    }
    func onStoreReady() {
        
    }
    func onBackToGame() {
        
    }
    func onNewProducts(cntProducts: Int) {
        
    }
    func onNewRewards(cntRewards: Int) {
        
    }
    func onScutiExchange(exchange: ScutiExchangeModel) {
        
    }
    func onUserToken(userToken: String) {
        
    }
    func onLogout() {
        
    }
    func onErrorOccurred(error: Error) {
        
    }

}
