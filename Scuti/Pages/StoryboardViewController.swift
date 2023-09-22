//
//  StoryboardViewController.swift
//  ScutiSDKSwift
//
//  Created by mac on 21/09/2023.
//

import UIKit
import ScutiSDKSwift
import SwiftUI

//https://sarunw.com/posts/swiftui-view-as-uiview-in-storyboard/

class StoryboardViewController: UIViewController {
    @IBOutlet weak var lblStoreReady: UILabel!
    @IBOutlet weak var lblUserAuthenticated: UILabel!
    @IBOutlet weak var lblCntProducts: UILabel!
    @IBOutlet weak var lblCntRewards: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBSegueAction func embedScutiButton(_ coder: NSCoder) -> UIViewController? {
        let controller = UIHostingController(coder: coder, rootView: ScutiButton())
        controller?.view.backgroundColor = .clear
        return controller
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
extension StoryboardViewController: ScutiSDKManagerDelegate {
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
}
