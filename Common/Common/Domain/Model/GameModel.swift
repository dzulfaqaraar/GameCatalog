//
//  GameModel.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public struct GameModel: Equatable {
    public var id: Int?
    public var rating: Double?
    public var name: String?
    public var image: String?
    public var released: String?
    public var descriptionRaw: String?
    public var developersName: String?
    public var publishersName: String?
    public var genres: String?

    public init(
        id: Int?,
        rating: Double?,
        name: String?,
        image: String?,
        released: String?,
        descriptionRaw: String?,
        developersName: String?,
        publishersName: String?,
        genres: String?
    ) {
        self.id = id
        self.rating = rating
        self.name = name
        self.image = image
        self.released = released
        self.descriptionRaw = descriptionRaw
        self.developersName = developersName
        self.publishersName = publishersName
        self.genres = genres
    }
}
