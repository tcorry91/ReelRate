//
//  TopSectionView.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import UIKit
import Combine

class TopSectionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Right Now"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.setLeftPadding(10) 
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGreen
        addSubview(titleLabel)
        addSubview(searchField)
        setupConstraints()
        searchField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    let searchTextPublisher = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
         
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
           
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 40),
            searchField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    @objc private func textDidChange() {
        if let text = searchField.text {
            searchTextPublisher.send(text)
        }
    }
}


private extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
