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
        let stackView = UIStackView(arrangedSubviews: [rateButtonView, favButton])
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
            rateButtonView.heightAnchor.constraint(equalToConstant: 55),
            favButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupCurrentRatingView() {
        print("setting up ratings VC for the ratings page")
        
        let ratingContainerView = UIView()
        ratingContainerView.layer.cornerRadius = 12
        ratingContainerView.clipsToBounds = true
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let currentRatingButton = UIButton(type: .system)
        currentRatingButton.setTitle("You’ve not yet rated this", for: .normal)
        currentRatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        currentRatingButton.setTitleColor(.white, for: .normal)
        currentRatingButton.backgroundColor = .green
        currentRatingButton.translatesAutoresizingMaskIntoConstraints = false
        currentRatingButton.addTarget(self, action: #selector(currentRatingTapped), for: .touchUpInside)
        
        let resetButton = UILabel()
        resetButton.text = "click to reset"
        resetButton.font = UIFont.systemFont(ofSize: 12, weight: .light)
        resetButton.textColor = .lightGray
        resetButton.textAlignment = .center
        resetButton.backgroundColor = .black
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        ratingContainerView.addSubview(currentRatingButton)
        ratingContainerView.addSubview(resetButton)
        addSubview(ratingContainerView)
        
        NSLayoutConstraint.activate([
            ratingContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            ratingContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            ratingContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -90),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 55),
            
            currentRatingButton.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
            currentRatingButton.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            currentRatingButton.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor),
            currentRatingButton.heightAnchor.constraint(equalTo: ratingContainerView.heightAnchor, multiplier: 0.5),
            
            resetButton.topAnchor.constraint(equalTo: currentRatingButton.bottomAnchor),
            resetButton.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor)
        ])
    }
    
    @objc private func currentRatingTapped() {
        delegate?.didTapCurrentRating()
    }
    
    private lazy var rateButtonView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 6
        containerView.layer.masksToBounds = false

  
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)

   
        let subtitleLabelTop = UILabel()
        subtitleLabelTop.text = "Rate it myself >"
        subtitleLabelTop.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabelTop.textColor = .white
        subtitleLabelTop.textAlignment = .center
        subtitleLabelTop.backgroundColor = .brown
        subtitleLabelTop.translatesAutoresizingMaskIntoConstraints = false

       
        let subtitleLabelBottom = UILabel()
        subtitleLabelBottom.text = "add personal rating"
        subtitleLabelBottom.font = UIFont.systemFont(ofSize: 12, weight: .light)
        subtitleLabelBottom.textColor = .yellow
        subtitleLabelBottom.textAlignment = .center
        subtitleLabelBottom.backgroundColor = .black
        subtitleLabelBottom.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(subtitleLabelTop)
        button.addSubview(subtitleLabelBottom)

     
        containerView.addSubview(button)

        NSLayoutConstraint.activate([
           
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

         
            subtitleLabelTop.topAnchor.constraint(equalTo: button.topAnchor),
            subtitleLabelTop.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            subtitleLabelTop.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            subtitleLabelTop.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.5),

        
            subtitleLabelBottom.topAnchor.constraint(equalTo: subtitleLabelTop.bottomAnchor),
            subtitleLabelBottom.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            subtitleLabelBottom.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            subtitleLabelBottom.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        return containerView
    }()



    
    private let currentRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "You've not yet rated this"
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("click to reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .green
        button.setTitleColor(.titleGreen, for: .normal)
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
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    @objc func favButtonTapped() {
        print("fav button tapped in ratings button view")
        delegate?.didTapFavourites()
    }
    
    
}


