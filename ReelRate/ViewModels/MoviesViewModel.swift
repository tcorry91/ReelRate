//
//  MoviesViewModel.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import UIKit
import Combine

class MoviesViewModel {
    @Published var genres: [Int: String] = [:]
    @Published var isSearching: Bool = false
    @Published var popularMovies: [Movie] = []
    @Published var searchResults: [SearchResult] = []
    private(set) var movies: [Movie] = [] {
        didSet {
            
            self.onMoviesUpdated?(movies)
        }
    }
    
    var onMoviesUpdated: (([Movie]) -> Void)?
    func fetchPopularMovies() {
        
        APIManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self?.genres = genres
                }
            case .failure(let error):
                print("Failed to fetch genres:", error)
            }
        }
        
        APIManager.shared.makeRequest(endpoint: APIEndpoint.popularMovies.rawValue) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.popularMovies = movieResponse.results
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    print("Data corrupted:", context.debugDescription)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch {
                    print("Error decoding data:", error)
                }
                
            case .failure(let error):
                print("API error:", error.localizedDescription)
            }
        }
    }
    
    func search(query: String) {
        APIManager.shared.multiSearch(query: query) { result in
            switch result {
            case .success(let searchResponse):
                DispatchQueue.main.async {
                    self.searchResults = searchResponse.results
                }
            case .failure(let error):
                print("Error fetching search results:", error)
            }
        }
    }
    
    func posterURL(for movie: Movie) -> URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    func posterURL(for result: SearchResult) -> URL? {
        guard let path = result.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    func formattedDate(for movie: Movie) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        
        if let date = inputFormatter.date(from: movie.releaseDate ?? "Release date not found") {
            return outputFormatter.string(from: date)
        }
        return movie.releaseDate ?? "Release date not found"
    }
    
    func genreNames(for movie: Movie) -> [String] {
        return movie.genreIds?.compactMap { genres[$0] } ?? []
    }
    
    func genreNames(for result: SearchResult) -> [String] {
        return result.genreIds?.compactMap { APIManager.shared.genres[$0] } ?? []
    }
}

class MovieDetailViewModel {
    private let movie: Movie
    private let sessionDataManager = SessionDataManager.shared

    @Published var isFavorited: Bool
    @Published var userRating: Int?
    
    init(movie: Movie) {
        self.movie = movie
        self.isFavorited = sessionDataManager.isMovieFavorited(movieID: movie.id ?? 0)
        self.userRating = sessionDataManager.getRating(for: movie.id ?? 0)
    }
    
    var title: String { movie.title ?? "No Title Available" }
    var overview: String { movie.overview ?? "No Description Available" }
    var posterPath: String? { movie.posterPath }
    
    var userScore: Double {
        return movie.voteAverage ?? 0.0
    }
    
    var year: String {
        guard let releaseDate = movie.releaseDate, !releaseDate.isEmpty else { return "Unknown" }
        return String(releaseDate.prefix(4))
    }
    
    var genreNames: [String] {
        movie.genreIds?.compactMap { APIManager.shared.genres[$0] } ?? []
    }
    
    func genreNames(for movie: Movie) -> [String] {
        return movie.genreIds?.compactMap { APIManager.shared.genres[$0] } ?? []
    }
    
    var posterURL: URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = movie.backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    func toggleFavorite() {
        sessionDataManager.toggleFavoriteStatus(for: movie)
        isFavorited.toggle()
    }
    
    func updateRating(to rating: Int) {
        guard let movieID = movie.id else {
            print("Error: Movie ID is nil")
            return
        }
        sessionDataManager.setRating(rating, for: movieID)
        userRating = rating
    }
}

extension MoviesViewModel {
    func year(for movie: Movie) -> String {
        guard let releaseDate = movie.releaseDate, !releaseDate.isEmpty else { return "Unknown" }
        return String(releaseDate.prefix(4))
    }
    
    func year(for result: SearchResult) -> String {
        guard let releaseDate = result.releaseDate, !releaseDate.isEmpty else { return "Unknown" }
        return String(releaseDate.prefix(4))
    }
}
