//
//  ProfileFooterView.swift
//  FireChat
//
//  Created by Magno Miranda Dantas on 30/06/21.
//

import UIKit

protocol ProfileFooterViewDelegate: AnyObject {
    func handleLogout()
}

class ProfileFooterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileFooterViewDelegate?
    
    private lazy var loggonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loggonButton)
        loggonButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        loggonButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loggonButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
}
