//
//  CustomBackButton.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import UIKit

class CustomBackButton: UIButton {
    init(title: String, textColor: UIColor = .white, chevronColor: UIColor = .white) {
        super.init(frame: .zero)
        setupButton(title: title, textColor: textColor, chevronColor: chevronColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, textColor: UIColor, chevronColor: UIColor) {
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(named: "chevron_left")?.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = chevronColor
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(chevronImageView)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        layer.cornerRadius = 11
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            chevronImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 6),
            chevronImageView.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    func addAction(to viewController: UIViewController, targetVC: MainViewController.Type) {
        addTarget(viewController, action: #selector(viewController.handleBackToMainTapped), for: .touchUpInside)
    }
}

