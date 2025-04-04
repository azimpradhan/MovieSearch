//
//  MovieSearchViewModel.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

import SwiftUI
import Combine

class MovieSearchViewModel: ObservableObject {
    let networkClient: NetworkClientProtocol

    @Published var searchText = ""
    @Published private(set) var searchResults: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var currentPage = 0
    @Published private(set) var totalPages = 0
    @Published private(set) var errorMessage: String?

    var hasMoreResults: Bool {
        currentPage > 0 && currentPage < totalPages
    }

    init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }

    private func fetchSearchResults(forQuery query: String, pageNumber: Int) async throws -> [Movie] {
        let moviePageEndpoint = MoviePageEndpoint(query: query, pageNumber: pageNumber)
        let moviePage = try await networkClient.fetchResponse(from: moviePageEndpoint)
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.currentPage = moviePage.page
            self.totalPages = moviePage.totalPages
            self.errorMessage = nil
        }
        return moviePage.results
    }

    private func handleError(_ error: Error) {
        switch error {
        case let urlError as URLError where urlError.code == .cancelled:
            return
        case is URLError:
            self.errorMessage = "Cannot display search results because a URLError has occured."
        case is ParseError:
            self.errorMessage = "Cannot display search results because a ParseError has occured."
        default:
            self.errorMessage = "Cannot display search results due to an unknown error. See logs for details."
        }
    }

    private func loadInitialSearchResults() async {
        await loadResultsPage(pageNumber: 1)
    }

    private func loadResultsPage(pageNumber: Int) async {
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.isLoading = true
        }
        var searchResults: [Movie] = []
        do {
            searchResults = try await fetchSearchResults(forQuery: searchText, pageNumber: pageNumber)
            await MainActor.run { [weak self, searchResults] in
                guard let self else { return }
                if pageNumber == 1 {
                    self.searchResults = searchResults
                } else {
                    self.searchResults.append(contentsOf: searchResults)
                }
                self.isLoading = false
            }
        } catch {
            print("Error loading search results \(error)")
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.handleError(error)
                self.isLoading = false
            }
        }
    }

    func loadMoreSearchResults() async {
        guard currentPage < totalPages else { return }
        await loadResultsPage(pageNumber: currentPage + 1)
    }

    func updateSearchResults() async {
        if searchText.isEmpty {
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.searchResults = []
                errorMessage = nil
                isLoading = false
            }
        } else {
            await loadInitialSearchResults()
        }
    }
}
