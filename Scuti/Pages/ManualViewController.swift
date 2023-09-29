//
//  ManualViewController.swift
//  ExampleScutiSwift
//
//  Created by mac on 21/09/2023.
//

import UIKit
import SwiftUI
import ScutiSDKSwift

class ManualViewController: UIViewController {
    @IBOutlet weak var lblStoreReady: UILabel!
    @IBOutlet weak var lblUserAuthenticated: UILabel!
    @IBOutlet weak var lblCntProducts: UILabel!
    @IBOutlet weak var lblCntRewards: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()


        let scutiButtonView = ScutiButton(frame: .zero)
        scutiButtonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scutiButtonView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scutiButtonView.trailingAnchor, constant: 10),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scutiButtonView.bottomAnchor, constant: 40),
            scutiButtonView.widthAnchor.constraint(equalToConstant: 260),
            scutiButtonView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScutiSDKManager.shared.delegate = self
        if ScutiSDKManager.shared.scutiEvents.isStoreReady {
            lblStoreReady.text = "Store Ready : ON"
            lblStoreReady.textColor = .green
        }
        if ScutiSDKManager.shared.scutiEvents.userToken != nil {
            lblUserAuthenticated.text = "User authenticated : YES"
            lblUserAuthenticated.textColor = .green
        }
        lblCntProducts.text = "New Products : \(ScutiSDKManager.shared.scutiEvents.cntNewProducts)"
        lblCntRewards.text = "New Rewards : \(ScutiSDKManager.shared.scutiEvents.cntRewards)"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ManualViewController: ScutiSDKManagerDelegate {
    func onStoreReady() {
        lblStoreReady.text = "Store Ready : ON"
        lblStoreReady.textColor = .green
    }
    func onLogout() {
        lblUserAuthenticated.text = "User authenticated : NO"
        lblUserAuthenticated.textColor = .red
    }
    func onNewProducts(cntProducts: Int) {
        lblCntProducts.text = "New Products : \(cntProducts)"
    }
    func onNewRewards(cntRewards: Int) {
        lblCntRewards.text = "New Rewards : \(cntRewards)"
    }
    func onUserToken(userToken: String) {
        lblUserAuthenticated.text = "User authenticated : YES"
        lblUserAuthenticated.textColor = .green
    }
    func onScutiButtonClicked() {
        
    }
    
    func onBackToGame() {
        
    }
    
    func onScutiExchange(exchange: ScutiSDKSwift.ScutiExchangeClass) {
        
    }
    
    func onErrorOccurred(error: Error) {
        
    }
}
