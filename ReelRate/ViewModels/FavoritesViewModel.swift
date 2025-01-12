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
    private var sessionDataManager = SessionDataManager.shared
    private let apiManager: APIManager
    
    init(sessionDataManager: SessionDataManager = .shared, apiManager: APIManager = .shared) {
        self.sessionDataManager = sessionDataManager
        self.apiManager = apiManager
    }
    
    func fetchFavorites() {
          favoriteMovies = sessionDataManager.getAllFavoritedMovies()
      }
    
    func getRating(for movieID: Int) -> Int? {
            return sessionDataManager.getRating(for: movieID)
        }
}
