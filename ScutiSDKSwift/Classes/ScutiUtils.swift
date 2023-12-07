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
@objc public class ScutiModelObjC: NSObject, ObservableObject {
    @objc @Published public var cntRewards: Int = 0
    @objc @Published public var cntNewProducts: Int = 0
    @objc @Published public var exchange: ScutiExchangeClass?
    @objc @Published public var backToGame: Bool = false
    @objc @Published public var isStoreReady: Bool = false
    @objc @Published public var userToken: String?
    
    public override init()
    {
    }
}

public struct ScutiExchangeModel: Decodable {
    public var id: String
    public var scutisSpent: Double
    public var currencyEarned: Double
    public var currencyName: String
    
    func convertToClass() -> ScutiExchangeClass {
        return ScutiExchangeClass(id: id, scutisSpent: scutisSpent, currencyEarned: currencyEarned, currencyName: currencyName)
    }
}
@objc public class ScutiExchangeClass: NSObject {
    public var id: String
    public var scutisSpent: Double
    public var currencyEarned: Double
    public var currencyName: String
    
    init(id: String, scutisSpent: Double, currencyEarned: Double, currencyName: String) {
        self.id = id
        self.scutisSpent = scutisSpent
        self.currencyEarned = currencyEarned
        self.currencyName = currencyName
    }
}
@objc public protocol ScutiSDKManagerDelegate {
    @objc func onScutiButtonClicked()
    @objc func onStoreReady()
    @objc func onBackToGame()
    @objc func onNewProducts(cntProducts: Int)
    @objc func onNewRewards(cntRewards: Int)
    @objc func onScutiExchange(exchange: ScutiExchangeClass)
    @objc func onUserToken(userToken: String)
    @objc func onLogout()

    func onErrorOccurred(error: Error)
}
@objc public protocol ScutiSDKManagerLogDelegate {
    @objc func onLog(log: String)
}
