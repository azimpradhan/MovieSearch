//
//  MovieDetailCell.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailCell: View {
    let movie: Movie

    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 0.8)
                .padding(.leading, 20)
                .foregroundColor(Color(.systemGray4))
            HStack(alignment: .top, spacing: 0) {
                if let imageUrl = movie.imageUrl {
                    WebImage(url: URL(string:imageUrl)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 120)
                    } placeholder: {
                        Image(systemName: "film")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 80, height: 120)
                    }
                } else {
                    Image(systemName: "film")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 80, height: 120)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .minimumScaleFactor(0.5)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    Text(movie.formattedReleaseDate ?? "N/A")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Viewer Rating")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                    Text("\(movie.formattedVoteAverage)/10")
                        .font(.system(size: 20, weight: .bold))
                    ProgressView(value: movie.voteAverage ?? 0, total: 10)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))

                }.padding(.leading, 10)


            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 140)
        }
    }
}

#Preview {
    MovieDetailCell(movie: Movie(title: "Avengers: Endgame", overview: "overview", voteAverage: 8.8, releaseDateString: "2020-12-31", posterPath: "p67m5dzwyxWd46a6of2c9IVfQz7.jpg"))
}
