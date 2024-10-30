//
//  movieResponse.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import Foundation

import Foundation


struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}


struct Movie: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let genreIDs: [Int]
    let popularity: Double
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
}
