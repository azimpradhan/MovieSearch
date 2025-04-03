//
//  MovieDBApiClient.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//
import Foundation

protocol Endpoint {
    associatedtype Response: Decodable

    var url: URL { get }
    func parseResponse(from data: Data) throws -> Response
}

protocol NetworkClientProtocol {
    func fetchResponse<T: Endpoint>(from endpoint: T) async throws -> T.Response
}

class NetworkClient: NetworkClientProtocol {
    static let shared = NetworkClient()

    private init() {
        // Private initializer to prevent instantiation
    }

    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }

    func fetchResponse<T: Endpoint>(from endpoint: T) async throws -> T.Response {
        let data = try await fetchData(from: endpoint.url)
        return try endpoint.parseResponse(from: data)
    }
}

