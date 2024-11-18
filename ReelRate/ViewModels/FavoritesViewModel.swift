//
//  FavoritesViewModel.swift
//  ReelRate
//
//  Created by Corry Timothy on 16/11/2024.
//

import Foundation
import Combine

class FavoritesViewModel {
    @Published var favoriteMovies: [Movie] = []
    private let sessionDataManager: SessionDataManager
    private let apiManager: APIManager
    
    init(sessionDataManager: SessionDataManager = .shared, apiManager: APIManager = .shared) {
        self.sessionDataManager = sessionDataManager
        self.apiManager = apiManager
    }
    
    func fetchFavorites() {
        let favoriteMovieIDs = sessionDataManager.getAllFavoritedMovies()
        
        guard !favoriteMovieIDs.isEmpty else {
            favoriteMovies = []
            return
        }
        
        let group = DispatchGroup()
        var movies: [Movie] = []
        
        for movieID in favoriteMovieIDs {
            group.enter()
            apiManager.getMovie(byID: movieID) { result in
                switch result {
                case .success(let movie):
                    movies.append(movie)
                    print("Fetched Movie:", movie.title ?? "No Title", "Poster Path:", movie.posterPath ?? "No Poster Path")
                case .failure(let error):
                    print("Error fetching movie: \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.favoriteMovies = movies
        }
        
        print("favourites data check", favoriteMovieIDs)
    }
    
    func getRating(for movieID: Int) -> Int? {
        print("Retrieved rating in fav view model", sessionDataManager.getRating(for: movieID))
            return sessionDataManager.getRating(for: movieID)
        }
    
}
