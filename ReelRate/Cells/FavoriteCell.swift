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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.67),
            
            ratingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

    }
    
    func configure(with movie: Movie, userRating: Int?) {
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            print("Constructed URL:", url?.absoluteString ?? "Invalid URL")
        } else {
            imageView.image = UIImage(named: "FavouriteIconFilled")
        }
        
        if let rating = userRating {
            ratingLabel.text = "\(rating)/10"
        } else {
            ratingLabel.text = "No Rating"
        }
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

