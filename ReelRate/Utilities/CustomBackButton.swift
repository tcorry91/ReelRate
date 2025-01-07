//
//  CustomBackButton.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import UIKit

class CustomBackButton: UIButton {
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    

    private func setupButton() {
    
        setTitle("<   Back to Search", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        layer.cornerRadius = 11
        clipsToBounds = true
        
    }
    
    
    func addPopAction(to viewController: UIViewController) {
        addTarget(viewController, action: #selector(viewController.handleBackButtonTapped), for: .touchUpInside)
    }
}
