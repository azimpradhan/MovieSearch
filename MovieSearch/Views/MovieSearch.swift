//
//  MovieSearch.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

import SwiftUI

struct MovieSearch: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    @State private var searchTask: Task<Void, Never>? = nil
    @State private var path: [Movie] = []


    var body: some View {

        NavigationStack(path: $path) {
            VStack {
                SearchBar(text: $viewModel.searchText) {
                    // cancel any ongoing search task
                    searchTask?.cancel()
                    searchTask = Task {
                        await viewModel.updateSearchResults()
                    }
                }
                if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                } else if viewModel.searchResults.isEmpty {
                    Spacer()
                    Text("No results")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.searchResults, id: \.self) { movie in
                                MovieCell(movie: movie)
                                    .onTapGesture {
                                        path.append(movie)
                                    }
                            }
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            } else {
                                // This is a final view whose onAppear is used to trigger the loading of more results
                                Color.clear
                                    .frame(height: 1)
                                    .padding(.horizontal)
                                    .background(Color(.systemGray4))
                                    .onAppear {
                                        // cancel any ongoing search task
                                        searchTask?.cancel()
                                        searchTask = Task {
                                            if viewModel.hasMoreResults {
                                                await viewModel.loadMoreSearchResults()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Movie Search")
            .navigationDestination(for: Movie.self) { movie in
                            MovieDetail(movie: movie)
                        }
        }
    }
}

#Preview {
    MovieSearch()
}
