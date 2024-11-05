//
//  MoviesViewModel.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import UIKit
import Combine

class MoviesViewModel {
    
    @Published var popularMovies: [Movie] = []
       @Published var searchResults: [SearchResult] = []
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
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.popularMovies = movieResponse.results
                        print("Decoded Popular Movies:", self?.popularMovies ?? [])
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
}
