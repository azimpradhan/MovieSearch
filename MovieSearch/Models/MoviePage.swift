//
//  MovieDog.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

struct MoviePage: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

