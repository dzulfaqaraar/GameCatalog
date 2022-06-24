//
//  GenreEntity.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public class GenreEntity {
    public let id: Int32?
    public let name: String?
    public let image: String?

    public init(
        id: Int32?,
        name: String?,
        image: String?
    ) {
        self.id = id
        self.name = name
        self.image = image
    }
}
