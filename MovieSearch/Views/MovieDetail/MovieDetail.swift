//
//  MovieDetail.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

import SwiftUI

struct MovieDetail: View {
    let movie: Movie
    var body: some View {
        ScrollView {
            VStack {
                MovieDetailCell(movie: movie)
                if !movie.overview.isEmpty {
                    OverviewCell(overviewText: movie.overview)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    MovieDetail(movie: Movie(title: "Avengers: Endgame", overview: "After the devastating events of Avengers: Infinity War, the universe is in ruins due to the efforts of the Mad Titan, Thanos. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos' actions and restore balance to the universe once and for all, no matter what consequences may be in store.", voteAverage: 8.8, releaseDateString: "2020-12-31", posterPath: "p67m5dzwyxWd46a6of2c9IVfQz7.jpg"))
}
