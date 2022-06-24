//
//  FavoriteEntity.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public class FavoriteEntity {
    public let id: Int32?
    public let image: String?
    public let name: String?
    public let released: String?
    public let rating: Double?
    public let date: Date?

    public init(
        id: Int32?,
        image: String?,
        name: String?,
        released: String?,
        rating: Double?,
        date: Date?
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.released = released
        self.rating = rating
        self.date = date
    }
}
