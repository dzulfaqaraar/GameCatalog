//
//  GenreModel.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public struct GenreModel: Equatable {
    public var id: Int?
    public var name: String?
    public var image: String?

    public init(
        id: Int?,
        name: String?,
        image: String?
    ) {
        self.id = id
        self.name = name
        self.image = image
    }
}
