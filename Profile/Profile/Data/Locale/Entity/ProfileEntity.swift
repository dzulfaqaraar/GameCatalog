//
//  ProfileEntity.swift
//  Catalog
//
//  Created by Dzulfaqar on 06/06/22.
//

import Foundation

public class ProfileEntity {
    public var image: Data?
    public var name: String
    public var website: String

    public init(
        image: Data?,
        name: String,
        website: String
    ) {
        self.image = image
        self.name = name
        self.website = website
    }
}
