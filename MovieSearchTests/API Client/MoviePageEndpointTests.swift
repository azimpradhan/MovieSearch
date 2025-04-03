//
//  MoviePageEndpointTests.swift
//  MovieSearchTests
//
//  Created by Azim Pradhan on 4/5/25.
//

import XCTest
@testable import MovieSearch

class MoviePageEndpointTests: XCTestCase {

    func testParseResponseValidJSON() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "title": "Inception",
                    "overview": "A mind-bending thriller",
                    "vote_average": 8.8,
                    "release_date": "2010-07-16",
                    "poster_path": "poster.jpg"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!

        let endpoint = MoviePageEndpoint(query: "Inception", pageNumber: 1)
        let moviePage = try endpoint.parseResponse(from: json)

        XCTAssertEqual(moviePage.page, 1)
        XCTAssertEqual(moviePage.results.count, 1)
        let movie = moviePage.results.first!
        XCTAssertEqual(movie.title, "Inception")
        XCTAssertEqual(movie.overview, "A mind-bending thriller")
        XCTAssertEqual(movie.formattedVoteAverage, "8.8")
        XCTAssertEqual(movie.releaseYear, "2010")
        XCTAssertEqual(movie.posterPath, "poster.jpg")
        XCTAssertEqual(movie.formattedReleaseDate, "July 16, 2010")
        XCTAssertEqual(movie.imageUrl, "https://image.tmdb.org/t/p/w200/poster.jpg")
        XCTAssertEqual(moviePage.totalPages, 1)
        XCTAssertEqual(moviePage.totalResults, 1)
    }

    func testParseResponseMissingFields() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "title": "Inception",
                    "overview": "A mind-bending thriller"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)! // missing poster_path, release_date, and vote_average

        let endpoint = MoviePageEndpoint(query: "Inception", pageNumber: 1)
        let moviePage = try endpoint.parseResponse(from: json)

        XCTAssertEqual(moviePage.page, 1)
        XCTAssertEqual(moviePage.results.count, 1)
        XCTAssertEqual(moviePage.results.first?.title, "Inception")
        XCTAssertEqual(moviePage.totalPages, 1)
        XCTAssertEqual(moviePage.totalResults, 1)
    }

    func testParseResponseInvalidJSON() {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "title": "Inception",
                    "overview": "A mind-bending thriller",
                    "vote_average": 8.8,
                    "release_date": "2010-07-16",
                    "poster_path": "/poster.jpg"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        """.data(using: .utf8)! // Missing closing brace

        let endpoint = MoviePageEndpoint(query: "Inception", pageNumber: 1)

        XCTAssertThrowsError(try endpoint.parseResponse(from: json)) { error in
            guard case ParseError.decodingError = error else {
                return XCTFail("Expected decodingError but got \(error)")
            }
        }
    }
}
