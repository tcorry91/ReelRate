//
//  movieResponse.swift
//  ReelRate
//
//  Created by Corry Timothy on 30/10/2024.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?
}

struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
           case adult
           case backdropPath = "backdrop_path"
           case genreIds = "genre_ids"
           case id
           case originalLanguage = "original_language"
           case originalTitle = "original_title"
           case overview
           case popularity
           case posterPath = "poster_path"
           case releaseDate = "release_date"
           case title
           case video
           case voteAverage = "vote_average"
           case voteCount = "vote_count"
       }
}

struct SearchResponse: Codable {
    let page: Int
    let results: [SearchResult]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResult: Codable {
    let id: Int
    let mediaType: String
    let name: String?
    let title: String?    
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let firstAirDate: String?
    let releaseDate: String?  
    let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case name
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case firstAirDate = "first_air_date"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}

