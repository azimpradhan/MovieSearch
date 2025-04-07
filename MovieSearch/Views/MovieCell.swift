//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieCell: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if let imageUrl = movie.imageUrl {

                WebImage(url: URL(string:imageUrl)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 75)
                } placeholder: {
                    Image(systemName: "film")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 75)
                }
            } else {
                Image(systemName: "film")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 75)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(movie.releaseYear ?? "N/A")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding(.leading, 20)


        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
            alignment: .top)
        .background(Color.white)
    }
}

#Preview {
    MovieCell(movie: Movie(title: "The Avengers", overview: "overview", voteAverage: 8.8, releaseDateString: "2020-12-31", posterPath: "p67m5dzwyxWd46a6of2c9IVfQz7.jpg"))
}
