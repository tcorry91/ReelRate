//
//  UIViewExtensions.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addCustomBackButton() {
        let backButton = CustomBackButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addPopAction(to: self)
        backButton.layer.zPosition = 1
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 110)
        ])
    }
    
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

