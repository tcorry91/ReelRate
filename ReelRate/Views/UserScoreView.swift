//
//  UserScoreView.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import UIKit

class UserScoreView: UIView {
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userScoreTextLabel: UILabel = {
        let label = UILabel()
        label.text = "user score"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scoreLabel)
        addSubview(userScoreTextLabel)
        addSubview(progressView)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            userScoreTextLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            userScoreTextLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 8),
            
            progressView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with score: Double) {
        let scorePercentage = Int(score * 10)
        scoreLabel.text = "\(scorePercentage)%"
        progressView.progress = Float(score / 10)
        if score >= 7 {
            progressView.progressTintColor = .systemGreen
        } else if score >= 4 {
            progressView.progressTintColor = .systemYellow
        } else {
            progressView.progressTintColor = .systemRed
        }
    }
}

