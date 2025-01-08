//
//  FavoriteCell.swift
//  ReelRate
//
//  Created by Corry Timothy on 18/11/2024.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
  
    private let myRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "My Rating"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupPosterCornerMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(myRatingLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.67),
            
            favoriteButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0),
            favoriteButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48),
            favoriteButton.widthAnchor.constraint(equalToConstant: 48),
            
            myRatingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            myRatingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            
            ratingLabel.topAnchor.constraint(equalTo: myRatingLabel.bottomAnchor, constant: 10),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupPosterCornerMask() {
        let cornerRadius: CGFloat = 40
        
        DispatchQueue.main.async {
            let path = UIBezierPath(
                roundedRect: self.imageView.bounds,
                byRoundingCorners: [.topRight],
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.imageView.layer.mask = mask
        }
    }
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "FavouriteIconFilled"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func favoriteButtonTapped() {
        //TODO: User can tap this and remove the item from favourites list
    }

    
    func configure(with movie: Movie, userRating: Int?) {
        print("Configuring cell with movie: \(movie.title ?? "Unknown") Poster Path: \(movie.posterPath ?? "No poster path")")
        
        if let posterPath = movie.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to decode image data")
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                    print("Image loaded successfully for \(movie.title ?? "Unknown")")
                }
            }.resume()
        } else {
            imageView.image = UIImage(named: "placeholder")
            print("No poster path, using placeholder for \(movie.title ?? "Unknown")")
        }
        
        ratingLabel.text = userRating != nil ? "\(userRating!)" : "0"
    }


    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }


}

