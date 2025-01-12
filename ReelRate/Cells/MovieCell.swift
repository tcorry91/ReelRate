//
//  MovieCell.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import UIKit
class MovieCell: UITableViewCell {
    
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
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
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
        stackView.backgroundColor = UIColor.clear
        return stackView
    }()
    
    func configure(with title: String, imageURL: URL?, date: String, genres: [String]) {
        titleLabel.text = title
        posterImageView.image = UIImage(named: "placeholder")
        loadImage(from: imageURL)
        dateLabel.text = date
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let limitedGenres = genres.prefix(2)
        for genre in limitedGenres {
            let genreLabel = createGenreLabel(with: genre)
            genreStackView.addArrangedSubview(genreLabel)
        }
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
    
    private func createGenreLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = "  \(text)  "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
