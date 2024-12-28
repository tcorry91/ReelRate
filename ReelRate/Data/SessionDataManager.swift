//
//  SessionDataManager.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import Foundation

class SessionDataManager {
    static let shared = SessionDataManager()
    private var favoriteMovies: [Int: Movie] = [:]
    private var movieRatings: [Int: Int] = [:]
    private init() {}
    
    func toggleFavoriteStatus(for movie: Movie) {
         if let _ = favoriteMovies[movie.id ?? 0] {
             favoriteMovies[movie.id ?? 0] = nil
         } else {
             favoriteMovies[movie.id ?? 0] = movie
         }
     }
    
    func getAllFavoritedMovies() -> [Movie] {
          return Array(favoriteMovies.values)
      }
    
    func isMovieFavorited(movieID: Int) -> Bool {
            return favoriteMovies[movieID] != nil
        }
    
    
    func getRating(for movieID: Int) -> Int? {
        print("Retrieved rating", movieRatings[movieID])
        return movieRatings[movieID]
    }
    
    func setRating(_ rating: Int, for movieID: Int) {
        movieRatings[movieID] = rating
        print("Set rating: \(rating) for movie ID: \(movieID)")
    }

}
