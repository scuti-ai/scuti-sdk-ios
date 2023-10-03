//
//  ScutiButton.swift
//  ScutiSDKSwift
//
//  Created by Adrian R on 14/09/2023.
//

import UIKit
import Combine

@objc public class ScutiButton: UIView {
    let buttonRadius = 10.0

    let imgNewProducts = UIImageView(image: ScutiIcons.newItem.image)
    let imgNewRewards = UIImageView(image: ScutiIcons.newReward.image)
    let lblCntNewRewards = UILabel(frame: .zero)

    private var cancellable: AnyCancellable?

    public init(vc: UIViewController) {
        super.init(frame: .zero)
        initializeView()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        backgroundColor = .clear
        
        let btn = UIButton(frame: .zero)
        btn.layer.cornerRadius = buttonRadius
        btn.backgroundColor = UIColor(red: 0.0546875, green: 0.046875, blue: 0.0625, alpha: 1)
        btn.layer.borderColor = UIColor(red: 0.1171875, green: 0.20703125, blue: 0.93359375, alpha: 1).cgColor
        btn.layer.borderWidth = 4
        btn.setImage(ScutiIcons.logo.image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            btn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            btn.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            btn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        
        imgNewProducts.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgNewProducts)
        NSLayoutConstraint.activate([
            imgNewProducts.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imgNewProducts.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imgNewProducts.widthAnchor.constraint(equalToConstant: 94),
            imgNewProducts.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        imgNewRewards.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgNewRewards)
        NSLayoutConstraint.activate([
            imgNewRewards.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imgNewRewards.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imgNewRewards.widthAnchor.constraint(equalToConstant: 30),
            imgNewRewards.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        lblCntNewRewards.textColor = .white
        lblCntNewRewards.font = UIFont.systemFont(ofSize: 14)
        lblCntNewRewards.translatesAutoresizingMaskIntoConstraints = false
        imgNewRewards.addSubview(lblCntNewRewards)
        NSLayoutConstraint.activate([
            lblCntNewRewards.centerXAnchor.constraint(equalTo: imgNewRewards.centerXAnchor),
            lblCntNewRewards.centerYAnchor.constraint(equalTo: imgNewRewards.centerYAnchor),
        ])
        checkStatus()
        
        cancellable = ScutiSDKManager.shared.scutiEvents.objectWillChange.sink(receiveValue: { value in
            self.perform(#selector(self.checkStatus), with: nil, afterDelay: 0.1)

        })
    }
    @objc func checkStatus() {
        lblCntNewRewards.text = "\(ScutiSDKManager.shared.scutiEvents.cntRewards)"
        imgNewProducts.isHidden = ScutiSDKManager.shared.scutiEvents.cntNewProducts == 0
        imgNewRewards.isHidden = ScutiSDKManager.shared.scutiEvents.cntRewards == 0
    }
    @objc func buttonClicked() {
        if let vc = parentViewController {
            ScutiSDKManager.shared.showScutiWebView(viewController: vc)
        }
    }
}
