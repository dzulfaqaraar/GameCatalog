//
//  GenreResponse.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public struct GenreResponse: Codable {
    public let results: [GenreResultResponse]?
}

public struct GenreResultResponse: Codable {
    public let id: Int?
    public let name: String?
    public let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageBackground = "image_background"
    }
}
