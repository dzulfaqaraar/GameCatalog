//
//  GameResponse.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public struct GameResponse: Codable {
    public let results: [GameResultResponse]?

    enum CodingKeys: String, CodingKey {
        case results
    }

    public init(results: [GameResultResponse]?) {
        self.results = results
    }
}

public struct GameResultResponse: Codable {
    public let id: Int?
    public let slug, name, released: String?
    public let descriptionRaw: String?
    public let backgroundImage: String?
    public let rating: Double?
    public let developers: [DeveloperResponse]?
    public let genres: [GenreResultResponse]?
    public let publishers: [PublisherResponse]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
        case rating, developers, genres, publishers
    }
}

public struct DeveloperResponse: Codable {
    public let name: String?
}

public struct PublisherResponse: Codable {
    public let name: String?
}
