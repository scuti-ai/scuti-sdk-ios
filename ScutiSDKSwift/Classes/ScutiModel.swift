//
//  ScutiEventMessenger.swift
//  ScutiSDK
//
//  Created by Mark Grossnickle on 5/4/23.
//

import Foundation

public class ScutiModel: ObservableObject {
    public init()
    {
        
    }
    @Published public var rewardCount: Int = 0
    @Published public var productCount: Int = 0
    @Published public var scutisExchanged: Int = 0
    @Published public var exitRequest: Bool = false
}
