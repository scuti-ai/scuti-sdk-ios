//
//  ViewController.swift
//  Scuti
//
//  Created by mac on 12/09/2023.
//

import UIKit
import WebKit
import ScutiSDKSwift
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var lblStoreReady: UILabel!
    @IBOutlet weak var lblCntProducts: UILabel!
    @IBOutlet weak var lblCntRewards: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScutiSDKManager.shared.delegate = self
    }
    @IBSegueAction func embedScutiButton(_ coder: NSCoder) -> UIViewController? {
        let controller = UIHostingController(coder: coder, rootView: ScutiButton())
        controller?.view.backgroundColor = .clear
        return controller
    }
    
}

extension ViewController: ScutiSDKManagerDelegate {
    func onStoreReady() {
        lblStoreReady.text = "Store Ready : ON"
        lblStoreReady.textColor = .green
    }
    func onLogout() {
        lblStoreReady.text = "Store Ready : OFF"
        lblStoreReady.textColor = .red
    }
    func onNewProducts(cntProducts: Int) {
        lblCntProducts.text = "New Products : \(cntProducts)"
    }
    func onNewRewards(cntRewards: Int) {
        lblCntProducts.text = "New Rewards : \(cntRewards)"
    }
    func onBackToGame() {
    }
    func onUserToken(userToken: String) {
        
    }
}
