//
//  RatingViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import UIKit

class RatingViewController: UIViewController, RatingButtonsViewDelegate {
    var viewModel: MovieDetailViewModel!
    let ratingButtonsView = RatingButtonsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupViews()
        ratingButtonsView.delegate = self
        configUI()
        print("Selected movie title within rating vc:", viewModel.title)
    }
    
    func configUI() {
        if let backdropURL = viewModel.backdropURL {
            URLSession.shared.dataTask(with: backdropURL) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.backDropImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        if let posterURL = viewModel.posterURL {
            URLSession.shared.dataTask(with: posterURL) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        
        titleLabel.text = viewModel.title
        
    }
 
    func setupViews() {
        view.addSubview(backDropImageView)
        view.addSubview(titleLabel)
        view.addSubview(posterImageView)
        view.addSubview(favoriteButton)
        view.addSubview(ratingButtonsView)
        view.addSubview(gotoFavouritesButton)
        ratingButtonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backDropImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backDropImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            backDropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backDropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 162),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            
            favoriteButton.bottomAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 0),
            favoriteButton.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 48),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48),
            
            ratingButtonsView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            ratingButtonsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 37),
            ratingButtonsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48),
            ratingButtonsView.heightAnchor.constraint(equalToConstant: 60),
            
            gotoFavouritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gotoFavouritesButton.topAnchor.constraint(equalTo: ratingButtonsView.bottomAnchor, constant: 20),
              gotoFavouritesButton.heightAnchor.constraint(equalToConstant: 50),
              gotoFavouritesButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
   
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Paw Patrol"
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "FavoriteIcon"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    let gotoFavouritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitle("Go to favourites", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(gotoFavouritesTapped), for: .touchUpInside)
        
        return button
    }()

    
    @objc func gotoFavouritesTapped() {
        print("go fav tapped")
    }
    
    @objc private func favoriteButtonTapped() {
        print("Favorite button tapped!")
        favoriteButton.setImage(UIImage(named: "FavouriteIconFilled"), for: .normal)
    }
    
    func didTapRateButton() {
        print("rate tapped")
    }
    
}

