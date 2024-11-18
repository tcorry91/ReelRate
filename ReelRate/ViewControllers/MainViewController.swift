//
//  ViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 22/10/2024.
//

import UIKit
import Combine

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var popularMovies: [Movie] {
        return viewModel.popularMovies
    }
    
    private let topSectionView = TopSectionView()
    private var cancellables = Set<AnyCancellable>()
    private var searchResults: [SearchResult] = []
    private let viewModel = MoviesViewModel()
    private var movies: [Movie] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Right Now"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    @objc func gotoFavouritesTapped() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Popular Right Now"
        view.addSubview(topSectionView)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        setupConstraints()
        topSectionView.searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(with: query)
            }
            .store(in: &cancellables)
        
        viewModel.$searchResults
            .sink { [weak self] results in
                self?.updateUI(with: results)
            }
            .store(in: &cancellables)
        
        viewModel.$searchResults
            .sink { [weak self] results in
                if !results.isEmpty {
                    self?.updateUI(with: results)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$searchResults
            .sink { [weak self] results in
                self?.updateUI(with: results)
            }
            .store(in: &cancellables)
        
        viewModel.fetchPopularMovies()
        
        viewModel.$popularMovies
            .sink { [weak self] movies in
                print("Popular movies count:", movies.count)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        fetchGenre()
    }
    
    func fetchGenre() {
        print("fetching genre")
        APIManager.shared.fetchGenres { result in
            switch result {
            case .success(let genres):
                print("Genres loaded:", genres)
            case .failure(let error):
                print("Error loading genres:", error.localizedDescription)
            }
        }
    }
    
    private func performSearch(with query: String) {
        if query.isEmpty {
            searchResults = []
            collectionView.reloadData()
        } else {
            viewModel.search(query: query)
        }
    }
    
    
    
    private func updateUI(with results: [SearchResult]) {
        self.searchResults = results
        self.collectionView.reloadData()
    }
    
    
    private func setupConstraints() {
        topSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSectionView.heightAnchor.constraint(equalToConstant: 120),
            
            collectionView.topAnchor.constraint(equalTo: topSectionView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.isEmpty ? popularMovies.count : searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        
        if searchResults.isEmpty {
            let movie = popularMovies[indexPath.item]
            cell.configure(
                with: movie.title ?? "No title",
                imageURL: viewModel.posterURL(for: movie)
            )
        } else {
            let result = searchResults[indexPath.item]
            cell.configure(
                with: result.title ?? result.name ?? "No title",
                imageURL: viewModel.posterURL(for: result)
            )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = popularMovies[indexPath.item]
        let detailViewModel = MovieDetailViewModel(movie: selectedMovie)
        let detailVC = MovieDetailsViewController()
        detailVC.viewModel = detailViewModel
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: 150)
    }
}

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

