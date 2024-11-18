//
//  RatingsButtonView.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import UIKit
protocol RatingButtonsViewDelegate: AnyObject {
    func didTapRateButton()
    func didTapCurrentRating()
    func didTapeResetButton()
    func didTapFavourites()
}

class RatingButtonsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureForMode()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureForMode()
    }
    
    enum Mode {
        case ratingAndFavorites
        case currentRating
    }

    var mode: Mode = .ratingAndFavorites {
        didSet {
            configureForMode()
        }
    }
    
    var rating: Int = 0 {
        didSet {
            currentRatingLabel.text = "You've rated this \(rating)"
        }
    }
    
    weak var delegate: RatingButtonsViewDelegate?
    
    private func configureForMode() {
        subviews.forEach { $0.removeFromSuperview() } 

        switch mode {
        case .ratingAndFavorites:
            setupRatingAndFavoritesView()
        case .currentRating:
            setupCurrentRatingView()
        }
    }

    private func setupRatingAndFavoritesView() {
        print("setup ratings + fav")

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

    private func setupCurrentRatingView() {
        print("setup current rating")

        let stackView = UIStackView(arrangedSubviews: [currentRatingLabel, resetButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            currentRatingLabel.heightAnchor.constraint(equalToConstant: 40),
            resetButton.heightAnchor.constraint(equalToConstant: 30),
            currentRatingLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(currentRatingTapped))
          currentRatingLabel.isUserInteractionEnabled = true
          currentRatingLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func currentRatingTapped() {
        delegate?.didTapCurrentRating()
    }
    
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
    
    private let currentRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "You've rated this 0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("click to reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .black
        button.setTitleColor(.systemGreen, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func resetButtonTapped() {
        delegate?.didTapeResetButton()
    }
    
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
        button.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    @objc func favButtonTapped() {
        print("fav button tapped in ratings button view")
        delegate?.didTapFavourites()
    }
    
    
}


