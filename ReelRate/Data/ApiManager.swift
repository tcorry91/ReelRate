//
//  ApiManager.swift
//  ReelRate
//
//  Created by Corry Timothy on 22/10/2024.
//

import Foundation

enum APIEndpoint: String {
    case authenticate = "authentication"
    case popularMovies = "movie/popular"
    case genreList = "genre/movie/list"
}

class APIManager {
    
    static let shared = APIManager()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiY2JmNzQwNDZhNWJkMGYyMWZmNzA0ZjYyMTM5ZTg4NyIsIm5iZiI6MTcyOTU5Mzk2NS44MDE1OTcsInN1YiI6IjY0MzBlYmI2MWY5OGQxMDJhNjJhYTk5YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.DoZn8-d7WEM6NbcpQC0Oz8UdelWRpqi5F3F9TX3eDzY"
    private(set) var genres: [Int: String] = [:]
    
    func makeRequest(endpoint: String, method: String = "GET", completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(bearerToken)"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func multiSearch(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let baseURL = "https://api.themoviedb.org/3/search/multi"
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(searchResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchGenres(completion: @escaping (Result<[Int: String], Error>) -> Void) {
        makeRequest(endpoint: APIEndpoint.genreList.rawValue) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                    self?.genres = Dictionary(uniqueKeysWithValues: response.genres.map { ($0.id, $0.name) })
                    
                    completion(.success(self?.genres ?? [:]))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

extension APIManager {
    var genreList: [Int: String] {
        return genres
    }
}
