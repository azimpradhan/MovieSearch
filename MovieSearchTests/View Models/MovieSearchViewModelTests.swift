//
//  MovieSearchViewModelTests.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/5/25.
//

import XCTest
@testable import MovieSearch

class MockNetworkClient: NetworkClientProtocol {
    func fetchResponse<T: Endpoint>(from endpoint: T) async throws -> T.Response {
        switch fetchResponseResult {
        case .success(let moviePage):
            return moviePage as! T.Response
        case .failure(let error):
            throw error
        case .none:
            fatalError("fetchResponseResult not set")
        }
    }
    var fetchResponseResult: Result<MoviePage, Error>?

}

class MovieSearchViewModelTests: XCTestCase {
    var viewModel: MovieSearchViewModel!
    var mockNetworkClient: MockNetworkClient!

    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        viewModel = MovieSearchViewModel(networkClient: mockNetworkClient)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkClient = nil
        super.tearDown()
    }

    func testLoadInitialSearchResultsSuccess() async {
        let moviePage = MoviePage(page: 1, results: [Movie(title: "Title", overview: "Overview", voteAverage: 5.0, releaseDateString: "1988-08-01", posterPath: nil)], totalPages: 2, totalResults: 2)
        mockNetworkClient.fetchResponseResult = .success(moviePage)

        viewModel.searchText = "Title"
        await viewModel.updateSearchResults()

        XCTAssertEqual(viewModel.searchResults.count, 1)
        XCTAssertEqual(viewModel.searchResults.first?.title, "Title")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadMoreSearchResultsSuccess() async {
        let initialMoviePage = MoviePage(page: 1, results: [Movie(title: "Title", overview: "Overview", voteAverage: 5.0, releaseDateString: "1988-08-01", posterPath: nil)], totalPages: 2, totalResults: 2)
        let nextMoviePage = MoviePage(page: 2, results: [Movie(title: "Title 2", overview: "Overview 2", voteAverage: 5.0, releaseDateString: "1989-08-01", posterPath: nil)], totalPages: 2, totalResults: 2)

        mockNetworkClient.fetchResponseResult = .success(initialMoviePage)

        viewModel.searchText = "Test"
        await viewModel.updateSearchResults()
        XCTAssertTrue(viewModel.hasMoreResults)

        mockNetworkClient.fetchResponseResult = .success(nextMoviePage)
        await viewModel.loadMoreSearchResults()

        XCTAssertEqual(viewModel.searchResults.count, 2)
        XCTAssertEqual(viewModel.searchResults[1].title, "Title 2")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadMoreSearchResultsNoMorePages() async {
        let moviePage = MoviePage(page: 1, results: [Movie(title: "Title", overview: "Overview", voteAverage: 5.0, releaseDateString: "1988-08-01", posterPath: nil)], totalPages: 1, totalResults: 1)

        mockNetworkClient.fetchResponseResult = .success(moviePage)

        viewModel.searchText = "Test"
        await viewModel.updateSearchResults()
        XCTAssertFalse(viewModel.hasMoreResults)
        await viewModel.loadMoreSearchResults()

        XCTAssertEqual(viewModel.searchResults.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadInitialSearchResultsURLError() async {
        let urlError = URLError(.notConnectedToInternet)
        mockNetworkClient.fetchResponseResult = .failure(urlError)

        viewModel.searchText = "Test"
        await viewModel.updateSearchResults()

        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Cannot display search results because a URLError has occured.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadInitialSearchResultsParseError() async {
        let parseError = ParseError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        mockNetworkClient.fetchResponseResult = .failure(parseError)

        viewModel.searchText = "Test"
        await viewModel.updateSearchResults()

        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Cannot display search results because a ParseError has occured.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadInitialSearchResultsUnknownError() async {
        let unknownError = NSError(domain: "Unknown", code: 999, userInfo: nil)
        mockNetworkClient.fetchResponseResult = .failure(unknownError)

        viewModel.searchText = "Test"
        await viewModel.updateSearchResults()

        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Cannot display search results due to an unknown error. See logs for details.")
        XCTAssertFalse(viewModel.isLoading)
    }
}
