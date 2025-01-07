//
//  EmptyFavouritesView.swift
//  ReelRate
//
//  Created by Corry Timothy on 7/1/2025.
//

import UIKit


class EmptyFavouritesView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no favourites"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
