//
//  FavoriteViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 14/11/2024.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let emptyFavouritesView = EmptyFavouritesView()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 245)
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        return collectionView
    }()
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomBackButton(title: "Back", textColor: UIColor.black, chevronColor: .brown, width: 88)
        setupUI()
        bindViewModel()
        viewModel.fetchFavorites()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(colorBanner)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(emptyFavouritesView)
        view.addSubview(searchForMoreButton)
        NSLayoutConstraint.activate([
            colorBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            colorBanner.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            colorBanner.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            colorBanner.heightAnchor.constraint(equalToConstant: 84),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 245),
            
            emptyFavouritesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                  emptyFavouritesView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchForMoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            searchForMoreButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55),
            searchForMoreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -55),
            searchForMoreButton.heightAnchor.constraint(equalToConstant: 56),
            
            
        ])
        view.sendSubviewToBack(colorBanner)
    }
 
    private func bindViewModel() {
        viewModel.$favoriteMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                self?.collectionView.reloadData()
                self?.emptyFavouritesView.isHidden = !movies.isEmpty
                self?.collectionView.isHidden = movies.isEmpty
            }
            .store(in: &cancellables)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Favourites"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let colorBanner: UIView = {
        let banner = UIView()
        banner.backgroundColor = .baseGreen
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
  
    let searchForMoreButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.grey237
        button.setTitle("Search for More", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.addTarget(self, action: #selector(searchForMore), for: .touchUpInside)
        return button
    }()

    
    @objc func searchForMore() {
        let mainVC = MainViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let movie = viewModel.favoriteMovies[indexPath.item]
        let userRating = viewModel.getRating(for: movie.id ?? 0)
        cell.configure(with: movie, userRating: userRating)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: user can select cells and goto the movies details page for selected movie
    }
    
}
