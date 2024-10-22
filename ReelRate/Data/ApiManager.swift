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
}

class APIManager {
    
    static let shared = APIManager()  
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiY2JmNzQwNDZhNWJkMGYyMWZmNzA0ZjYyMTM5ZTg4NyIsIm5iZiI6MTcyOTU5Mzk2NS44MDE1OTcsInN1YiI6IjY0MzBlYmI2MWY5OGQxMDJhNjJhYTk5YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.DoZn8-d7WEM6NbcpQC0Oz8UdelWRpqi5F3F9TX3eDzY"
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
}
