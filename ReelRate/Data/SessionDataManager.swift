//
//  SessionDataManager.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import Foundation

class SessionDataManager {
    static let shared = SessionDataManager()
//    private var favoriteMovies: Set<Int> = []
    private var favoriteMovies: [Int: Movie] = [:]
    private var movieRatings: [Int: Int] = [:]
    private init() {}
//    func isMovieFavorited(movieID: Int) -> Bool {
//        return favoriteMovies.contains(movieID)
//    }
    
//    func toggleFavoriteStatus(for movieID: Int) {
//        if favoriteMovies.contains(movieID) {
//            favoriteMovies.remove(movieID)
//            print("Removed movie ID \(movieID) from favorites")
//        } else {
//            favoriteMovies.insert(movieID)
//            print("Added movie ID \(movieID) to favorites")
//        }
//    }
    
    func toggleFavoriteStatus(for movie: Movie) {
         if let _ = favoriteMovies[movie.id ?? 0] {
             favoriteMovies[movie.id ?? 0] = nil // Remove if already favorited
         } else {
             favoriteMovies[movie.id ?? 0] = movie // Add movie details
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
    
    
    
//    func getAllFavoritedMovies() -> [Int] {
//          return Array(favoriteMovies)
//      }
}
