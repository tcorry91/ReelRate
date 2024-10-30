//
//  MoviesViewModel.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import Foundation
import Foundation

class MoviesViewModel {
    

    private(set) var movies: [Movie] = [] {
        didSet {
          
            self.onMoviesUpdated?(movies)
        }
    }
    
 
    var onMoviesUpdated: (([Movie]) -> Void)?
    

    func fetchPopularMovies() {
        APIManager.shared.makeRequest(endpoint: APIEndpoint.popularMovies.rawValue) { [weak self] result in
            switch result {
            case .success(let data):
                print("Raw JSON data:", String(data: data, encoding: .utf8) ?? "No data")
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.movies = movieResponse.results
                    }
                } catch {
                    print("Error decoding data:", error.localizedDescription)
                }
                
            case .failure(let error):
                print("API error:", error.localizedDescription)
            }
        }
    }

    func posterURL(for movie: Movie) -> URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    

    func formattedDate(for movie: Movie) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        
        if let date = inputFormatter.date(from: movie.releaseDate) {
            return outputFormatter.string(from: date)
        }
        return movie.releaseDate
    }
}
