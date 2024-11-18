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
        setupUI()
        bindViewModel()
        viewModel.fetchFavorites()
        print("data check", viewModel.favoriteMovies)
        print("Poster Path for Movie:", viewModel.favoriteMovies.first?.posterPath ?? "No Poster Path")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Favourites"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func bindViewModel() {
        viewModel.$favoriteMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                print("Movies updated in ViewModel:", movies)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    
  
}


extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Collection view item count:", viewModel.favoriteMovies.count)
        return viewModel.favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let movie = viewModel.favoriteMovies[indexPath.item]
        
        let userRating = viewModel.getRating(for: movie.id ?? 0) 
        print("Configuring cell with movie:", movie.title ?? "No Title", "Poster Path:", movie.posterPath ?? "No Poster Path")
        cell.configure(with: movie, userRating: userRating)
        return cell
    }



}
