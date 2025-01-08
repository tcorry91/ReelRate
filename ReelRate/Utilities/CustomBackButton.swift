//
//  CustomBackButton.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import UIKit

import UIKit

class CustomBackButton: UIButton {
    
  
    init(title: String, textColor: UIColor = .white) {
            super.init(frame: .zero)
            setupButton(title: title, textColor: textColor)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func setupButton(title: String, textColor: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
        backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        layer.cornerRadius = 11
        clipsToBounds = true
    }
    
   
    func addAction(to viewController: UIViewController, targetVC: MainViewController.Type) {
        addTarget(viewController, action: #selector(viewController.handleBackToMainTapped), for: .touchUpInside)
    }
}
