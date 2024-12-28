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
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .titleGreen
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let searchField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        textField.layer.cornerRadius = 21
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.setLeftPadding(20) 
        return textField
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.baseGreen
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
            
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            searchField.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            searchField.heightAnchor.constraint(equalToConstant: 43),
            searchField.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            
            titleLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 50),
            titleLabel.leftAnchor.constraint(equalTo: searchField.leftAnchor, constant: 0),
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

