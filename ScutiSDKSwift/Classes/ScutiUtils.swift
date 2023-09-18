//
//  ScutiUtils.swift
//  
//
//  Created by Mark Grossnickle on 5/2/23.
//

import Foundation

public class ScutiModel: ObservableObject {
    public init()
    {
        
    }
    @Published public var cntRewards: Int = 0
    @Published public var cntNewProducts: Int = 0
    @Published public var exchange: ScutiExchangeModel?
    @Published public var exitScuti: Bool = false
    @Published public var isStoreReady: Bool = false
}

public struct ScutiExchangeModel: Decodable {
    public var id: String
    public var scutisSpent: Double
    public var currencyEarned: Double
    public var currencyName: String
    
//    func modelChange() -> ScutiExchange {
//        return ScutiExchange(id: id, scutisSpent: scutisSpent, currencyEarned: currencyEarned, currencyName: currencyName)
//    }
}

//@objc public class ScutiExchange: NSObject {
//    public var id: String
//    public var scutisSpent: Double
//    public var currencyEarned: Double
//    public var currencyName: String
//
//    init(id: String, scutisSpent: Double, currencyEarned: Double, currencyName: String) {
//        self.id = id
//        self.scutisSpent = scutisSpent
//        self.currencyEarned = currencyEarned
//        self.currencyName = currencyName
//    }
//}
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
