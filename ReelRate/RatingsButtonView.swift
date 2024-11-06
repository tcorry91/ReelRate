//
//  RatingsButtonView.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import UIKit

protocol RatingButtonsViewDelegate: AnyObject {
    func didTapRateButton()
}

class RatingButtonsView: UIView {
    weak var delegate: RatingButtonsViewDelegate?
    private let rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rate it myself >", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.brown 
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "add personal rating"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.lightText
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: button.titleLabel!.bottomAnchor, constant: 2)
        ])
        
        return button
    }()
    
    
      @objc private func rateButtonTapped() {
          delegate?.didTapRateButton()
      }
    
    
    private let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Favs", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.brown, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.88, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        let stackView = UIStackView(arrangedSubviews: [rateButton, favButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rateButton.heightAnchor.constraint(equalToConstant: 60),
            favButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
