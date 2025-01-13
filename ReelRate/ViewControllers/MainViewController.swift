//
//  ViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 22/10/2024.
//

import UIKit
import Combine

class MainViewController: UIViewController, UITableViewDelegate {
    
    private var popularMovies: [Movie] {
        return viewModel.popularMovies
    }
    
    private var tableView: UITableView!
    private let topSectionView = TopSectionView()
    private var cancellables = Set<AnyCancellable>()
    private var searchResults: [SearchResult] = []
    private let viewModel = MoviesViewModel()
    private var movies: [Movie] = []
    
    @objc func gotoFavouritesTapped() {
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoriteViewController(viewModel: favoritesViewModel)
        navigationController?.pushViewController(favoritesVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView = UITableView()
           tableView.translatesAutoresizingMaskIntoConstraints = false
           tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorStyle = .none
           tableView.backgroundColor = .clear
           view.addSubview(tableView)
        view.addSubview(topSectionView)
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
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        fetchGenre()
        
        viewModel.$isSearching
            .receive(on: RunLoop.main)
            .sink { [weak self] isSearching in
                self?.topSectionView.isSearching = isSearching
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func fetchGenre() {
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
            tableView.reloadData()
            viewModel.isSearching = false
        } else {
            viewModel.isSearching = true
            viewModel.search(query: query)
        }
    }
    
    private func updateUI(with results: [SearchResult]) {
        self.searchResults = results
        self.tableView.reloadData()
    }
    
    private func setupConstraints() {
        topSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSectionView.heightAnchor.constraint(equalToConstant: 211),
            
            
            tableView.topAnchor.constraint(equalTo: topSectionView.bottomAnchor, constant: 0),
                        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

  
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? popularMovies.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        
        if searchResults.isEmpty {
            let movie = popularMovies[indexPath.row]
            let genres = viewModel.genreNames(for: movie)
            cell.configure(
                with: movie.title ?? "No title",
                imageURL: viewModel.posterURL(for: movie),
                date: viewModel.year(for: movie),
                genres: genres
            )
        } else {
            
            let result = searchResults[indexPath.row]
            let genres = viewModel.genreNames(for: result)
            let formattedDate = viewModel.year(for: result)
            cell.configure(
                with: result.title ?? result.name ?? "No title",
                imageURL: viewModel.posterURL(for: result),
                date: formattedDate,
                genres: genres
            )
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedMovie: Movie
           
           if searchResults.isEmpty {
               selectedMovie = popularMovies[indexPath.row]
           } else {
               let searchResult = searchResults[indexPath.row]
             
               selectedMovie = Movie(
                   adult: false,
                   backdropPath: searchResult.backdropPath,
                   genreIds: searchResult.genreIds,
                   id: searchResult.id,
                   originalLanguage: nil,
                   originalTitle: nil,
                   overview: searchResult.overview,
                   popularity: searchResult.popularity,
                   posterPath: searchResult.posterPath,
                   releaseDate: searchResult.releaseDate,
                   title: searchResult.title ?? searchResult.name,
                   video: false,
                   voteAverage: searchResult.voteAverage,
                   voteCount: searchResult.voteCount
               )
           }
           
           let detailViewModel = MovieDetailViewModel(movie: selectedMovie)
           let detailVC = MovieDetailsViewController()
           detailVC.viewModel = detailViewModel
           navigationController?.pushViewController(detailVC, animated: true)
       }
    
}


//TODO: update proper sizes with the custom fonts
//TODO: implement custom fonts
//TODO: readme
//TODO: testing
//TODO: reusable labels
