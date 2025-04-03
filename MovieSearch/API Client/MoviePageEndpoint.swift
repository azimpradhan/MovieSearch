//
//  Endpoint.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/4/25.
//
import Foundation



enum ParseError: Error {
    case decodingError(Error)
    case unknownError(Error)
}

class MoviePageEndpoint: Endpoint {
    typealias Response = MoviePage

    let query: String
    let pageNumber: Int

    private static let baseURL = "https://api.themoviedb.org"
    private static let apiKey: String = {
        let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_API_KEY") as? String
        return apiKey ?? ""
    }()

    init(query: String, pageNumber: Int) {
        self.query = query
        self.pageNumber = pageNumber
    }

    var url: URL {
        var components = URLComponents(string: "\(MoviePageEndpoint.baseURL)/3/search/movie")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "api_key", value: MoviePageEndpoint.apiKey)
        ]
        return components.url!
    }

    func parseResponse(from data: Data) throws -> MoviePage {
        do {
            let decoder = JSONDecoder()
            let moviePage = try decoder.decode(MoviePage.self, from: data)
            return moviePage
        }  catch let error as DecodingError {
            throw ParseError.decodingError(error)
        } catch {
            throw ParseError.unknownError(error)
        }
    }
}


