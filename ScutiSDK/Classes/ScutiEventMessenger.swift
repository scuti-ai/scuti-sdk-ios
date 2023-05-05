//
//  ScutiEventMessenger.swift
//  ScutiSDK
//
//  Created by Mark Grossnickle on 5/4/23.
//

import Foundation

public class ScutiModel: ObservableObject {
    @Published var rewardCount: Int = 0
    @Published var productCount: Int = 0
    @Published var scutisExchanged: Int = 0 
   
}
