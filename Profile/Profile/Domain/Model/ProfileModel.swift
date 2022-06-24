//
//  ProfileModel.swift
//  Profile
//
//  Created by Dzulfaqar on 18/06/22.
//

import Foundation

public struct ProfileModel {
    public var image: Data?
    public var name: String
    public var website: String

    init(
        image: Data?,
        name: String,
        website: String
    ) {
        self.image = image
        self.name = name
        self.website = website
    }
}
