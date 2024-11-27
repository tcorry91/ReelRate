//
//  MovieDetailsViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 5/11/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController, RatingButtonsViewDelegate {
    private let userScoreView = UserScoreView()
    var viewModel: MovieDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    let ratingButtonsView = RatingButtonsView()
    private lazy var tinyTitleLabel = createLabel(fontSize: 24, weight: .bold)
    private lazy var yearLabel = createLabel(fontSize: 18, weight: .regular, textColor: .darkGray)
    private lazy var genreLabel = createLabel(fontSize: 14, weight: .medium, textColor: .systemGray)
    
    private let ratingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureUI()
        bindViewModel()
        ratingButtonsView.delegate = self
        ratingButtonsView.mode = .ratingAndFavorites
        updateFavoriteButtonAppearance()
        print("MovieDetailsViewController loaded with ViewModel:", viewModel ?? "nil")
    }
    
    private func bindViewModel() {
        viewModel.$isFavorited
            .sink { [weak self] isFavorited in
                let buttonTitle = isFavorited ? "Unfavorite" : "Favorite"
                self?.favoriteButton.setTitle(buttonTitle, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$userRating
            .sink { [weak self] rating in
                self?.ratingLabel.text = rating != nil ? "Rating: \(rating!)" : "Rate this movie"
            }
            .store(in: &cancellables)
    }
    
    @objc private func toggleFavorite() {
        print("togglong favourites? what is this")
        viewModel.toggleFavorite()
    }
    
    func rateMovie(rating: Int) {
        viewModel.updateRating(to: rating)
    }
    
    func setupViews() {
        view.addSubview(backDropImageView)
        backDropImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backDropImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backDropImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backDropImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: backDropImageView.centerYAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: backDropImageView.leftAnchor, constant: 28).isActive = true
        
        view.addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: backDropImageView.bottomAnchor, constant: -40).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 162).isActive = true
        
        view.addSubview(userScoreView)
        userScoreView.translatesAutoresizingMaskIntoConstraints = false
        userScoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        userScoreView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        userScoreView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        userScoreView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: backDropImageView.bottomAnchor, constant: 0).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 5).isActive = true
        
        
        view.addSubview(ratingButtonsView)
        ratingButtonsView.translatesAutoresizingMaskIntoConstraints = false
        ratingButtonsView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 60).isActive = true
        ratingButtonsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 37).isActive = true
        ratingButtonsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48).isActive = true
        ratingButtonsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        view.addSubview(overviewStackView)
        overviewStackView.topAnchor.constraint(equalTo: ratingButtonsView.bottomAnchor, constant: 30).isActive = true
        overviewStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        overviewStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(favoriteButton)
        favoriteButton.bottomAnchor.constraint(equalTo: posterImageView.topAnchor, constant: -20).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 10).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func didTapRateButton() {
        let ratingVC = RatingViewController()
        ratingVC.viewModel = self.viewModel
        navigationController?.pushViewController(ratingVC, animated: true)
    }
    
    
    private func createLabel(fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tinyTitleLabel, yearLabel, genreLabel, userScoreView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0 // Allows multiline for long overviews
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [overviewHeaderLabel, overviewTextLabel])
        stackView.axis = .vertical
        stackView.spacing = 8 // Space between header and text
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.yellow
        return imageView
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
    
    @objc private func favoriteButtonTapped() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil in favoriteButtonTapped!")
            return
        }

        print("Favorite button tapped! in the movie data vc")

        // Toggle the favorite state in the ViewModel
        viewModel.toggleFavorite()

        // Update the button appearance based on the new state
        updateFavoriteButtonAppearance()
    }


    
    private func updateFavoriteButtonAppearance() {
        if viewModel.isFavorited {
            favoriteButton.setImage(UIImage(named: "FavouriteIconFilled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteIcon"), for: .normal)
        }
    }

    
    internal func didTapeResetButton() {
        print("reset button tappeded")
    }
    
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.yellow
        return imageView
    }()
    
    
    private func configureUI() {
        guard let viewModel = viewModel else { return }
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
        tinyTitleLabel.text = viewModel.title
        yearLabel.text = viewModel.year
        genreLabel.text = viewModel.genreNames.joined(separator: ", ")
        
        
        userScoreView.configure(with: viewModel.userScore)
        overviewTextLabel.text = viewModel.overview
    }
  
    @objc func gotoFavouritesTapped() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

        
    func didTapFavourites() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    func didTapCurrentRating() {
        print("movie details vc didTap current rating make this optional?!")
    }
    

}
