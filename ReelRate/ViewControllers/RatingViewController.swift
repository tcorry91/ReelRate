//
//  RatingViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import UIKit
import Combine

class RatingViewController: UIViewController, RatingButtonsViewDelegate {
    
    var viewModel: MovieDetailViewModel!
    let ratingButtonsView = RatingButtonsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseGreen
        addCustomBackButton(title: "  Back to Search")
        setupPosterCornerMask()
        setupViews()
        ratingButtonsView.delegate = self
        configUI()
        ratingButtonsView.mode = .currentRating
        let favoriteImage = viewModel.isFavorited ? "FavouriteIconFilled" : "FavoriteIcon"
        favoriteButton.setImage(UIImage(named: favoriteImage), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratingButtonsView.refresh(with: viewModel.userRating ?? 0)
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
    
    func didTapCurrentRating() {
        print("checking this didTapCurrentRating is running ")
        presentPicker()
    }
    
    private func presentPicker() {
        print("present picker")
        let alert = UIAlertController(title: "Select Rating", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 140))
        picker.dataSource = self
        picker.delegate = self
        alert.view.addSubview(picker)
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            self?.updateRating(selectedRow + 1)
            print("Selected row in picker:", selectedRow)
            self?.refreshView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func refreshView() {
        ratingButtonsView.refresh(with: viewModel.userRating ?? 0)
    }

    
    func setupViews() {
        view.addSubview(backDropImageView)
        view.addSubview(titleLabel)
        view.addSubview(youRatedLabel)
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
            
            youRatedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            youRatedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 162),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
           
            favoriteButton.bottomAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 15),
            favoriteButton.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: -15),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48),
            favoriteButton.widthAnchor.constraint(equalToConstant: 48),
            
            ratingButtonsView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            ratingButtonsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 37),
            ratingButtonsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48),
            ratingButtonsView.heightAnchor.constraint(equalToConstant: 60),
            
            gotoFavouritesButton.topAnchor.constraint(equalTo: ratingButtonsView.bottomAnchor, constant: 20),
            gotoFavouritesButton.heightAnchor.constraint(equalToConstant: 56),
            gotoFavouritesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            gotoFavouritesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
        ])
    }
    
    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    private func setupPosterCornerMask() {
        let cornerRadius: CGFloat = 40
        
        DispatchQueue.main.async {
            
            let path = UIBezierPath(
                roundedRect: self.posterImageView.bounds,
                byRoundingCorners: [.topRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.posterImageView.layer.mask = mask
            let borderLayer = CAShapeLayer()
            borderLayer.path = path.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.lineWidth = 12
            borderLayer.frame = self.posterImageView.bounds
            self.posterImageView.layer.addSublayer(borderLayer)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private let youRatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You rated this"
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(gotoFavouritesTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func gotoFavouritesTapped() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil in RatingViewController!")
            return
        }
        
        print("Favorite button tapped in the Rating VC!")
        viewModel.toggleFavorite()
        let favoriteImage = viewModel.isFavorited ? "FavouriteIconFilled" : "FavouriteIcon"
        favoriteButton.setImage(UIImage(named: favoriteImage), for: .normal)
    }

    private func updateRating(_ rating: Int) {
        viewModel.updateRating(to: rating)
        DispatchQueue.main.async {
            self.ratingButtonsView.refresh(with: rating) 
        }
    }

    
    func didTapeResetButton() {
        ratingButtonsView.rating = 0
    }
    
    
}


extension RatingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    
}

