//
//  FavoriteModel.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public struct FavoriteModel: Equatable {
    public var id: Int32?
    public var image: String?
    public var name: String?
    public var released: String?
    public var rating: Double?
    public var date: Date?

    public init(
        id: Int32? = nil,
        image: String? = nil,
        name: String? = nil,
        released: String? = nil,
        rating: Double? = nil,
        date: Date? = nil
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.released = released
        self.rating = rating
        self.date = date
    }
}
