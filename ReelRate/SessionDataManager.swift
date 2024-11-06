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
        } else {
            favoriteMovies.insert(movieID)
        }
    }
    
    func getRating(for movieID: Int) -> Int? {
        return movieRatings[movieID]
    }
    
    func setRating(_ rating: Int, for movieID: Int) {
        movieRatings[movieID] = rating
    }
}
