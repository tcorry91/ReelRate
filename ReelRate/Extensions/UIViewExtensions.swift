//
//  UIViewExtensions.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import UIKit


extension UIViewController {
    
    func addCustomBackButton(title: String, textColor: UIColor = .white, chevronColor: UIColor = .white, width: CGFloat = 135) {
         let backButton = CustomBackButton(title: title, textColor: textColor, chevronColor: chevronColor)
         backButton.translatesAutoresizingMaskIntoConstraints = false
         backButton.addAction(to: self, targetVC: MainViewController.self)
         backButton.layer.zPosition = 1
         view.addSubview(backButton)
         
         NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                       backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                       backButton.heightAnchor.constraint(equalToConstant: 25),
                       backButton.widthAnchor.constraint(equalToConstant: width)
         ])
     }
    
    @objc func handleBackToMainTapped() {
    
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is MainViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
    }
}



