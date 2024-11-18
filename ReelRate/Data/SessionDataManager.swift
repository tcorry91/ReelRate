//
//  SessionDataManager.swift
//  ReelRate
//
//  Created by Corry Timothy on 6/11/2024.
//

import Foundation

class SessionDataManager {
    static let shared = SessionDataManager()
    private var favoriteMovies: Set<Int> = []
    private var movieRatings: [Int: Int] = [:]
    private init() {}
    func isMovieFavorited(movieID: Int) -> Bool {
        return favoriteMovies.contains(movieID)
    }
    
    func toggleFavoriteStatus(for movieID: Int) {
        if favoriteMovies.contains(movieID) {
            favoriteMovies.remove(movieID)
            print("Removed movie ID \(movieID) from favorites")
        } else {
            favoriteMovies.insert(movieID)
            print("Added movie ID \(movieID) to favorites")
        }
    }
    
    func getRating(for movieID: Int) -> Int? {
        print("Retrieved rating", movieRatings[movieID])
        return movieRatings[movieID]
    }
    
    func setRating(_ rating: Int, for movieID: Int) {
        movieRatings[movieID] = rating
        print("Set rating: \(rating) for movie ID: \(movieID)")
    }
    
    func getAllFavoritedMovies() -> [Int] {
          return Array(favoriteMovies)
      }
    
}
