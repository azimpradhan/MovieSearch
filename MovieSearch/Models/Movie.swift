//
//  Movie.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//
import Foundation

struct Movie: Codable, Hashable, Identifiable {
    let id = UUID()
    let title: String
    let overview: String
    let voteAverage: Double?
    let releaseDateString: String?
    let posterPath: String?

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()


    private static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()


    var imageUrl: String? {
        guard let posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w200/\(posterPath)"
    }

    private var releaseDate: Date? {
        guard let releaseDateString else { return nil }
        return Movie.fullDateFormatter.date(from: releaseDateString)
    }

    var formattedReleaseDate: String? {
        guard let releaseDate else { return nil }
        return Movie.longDateFormatter.string(from: releaseDate)
    }

    var releaseYear: String? {
        guard let releaseDate else { return nil }
        return Movie.yearFormatter.string(from: releaseDate)
    }

    var formattedVoteAverage: String {
        return String(format: "%.1f", voteAverage ?? 0.0)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case voteAverage = "vote_average"
        case releaseDateString = "release_date"
        case posterPath = "poster_path"
    }
}
