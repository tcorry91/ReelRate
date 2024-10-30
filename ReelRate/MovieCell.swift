//
//  MovieCell.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date Label"
        return label
    }()
    
    private let userScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100%"
        return label
    }()
    
    private let userScoreActualLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Score"
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.yellow
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1) 
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(userScoreLabel)
        contentView.addSubview(userScoreActualLabel)
        contentView.addSubview(genreStackView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 34),
            posterImageView.widthAnchor.constraint(equalToConstant: 87),
            posterImageView.heightAnchor.constraint(equalToConstant: 134),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 30),
            
            userScoreLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            userScoreLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 30),
            
            userScoreActualLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            userScoreActualLabel.leftAnchor.constraint(equalTo: userScoreLabel.rightAnchor, constant: 10),
            
            genreStackView.topAnchor.constraint(equalTo: userScoreActualLabel.bottomAnchor, constant: 20),
            genreStackView.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 30),
            
            
        ])
    }
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configure(with title: String, image: UIImage?, genres: [String]) {
        titleLabel.text = title
        posterImageView.image = image
        
        
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        for genre in genres.prefix(2) {
            let label = createGenreLabel(with: genre)
            genreStackView.addArrangedSubview(label)
        }
    }
    
    private func createGenreLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        return label
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
