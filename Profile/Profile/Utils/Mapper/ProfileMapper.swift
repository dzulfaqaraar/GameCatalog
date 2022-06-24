//
//  ProfileMapper.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Common
import Core
import Foundation

public struct ProfileTransformer: Mapper {
    public typealias Response = Any
    public typealias Entity = ProfileEntity
    public typealias Domain = ProfileModel

    public init() {}

    public func transformResponseToDomain(response _: Any) -> ProfileModel {
        fatalError()
    }

    public func transformResponseToEntity(response _: Any) -> ProfileEntity {
        fatalError()
    }

    public func transformEntityToDomain(entity: ProfileEntity) -> ProfileModel {
        ProfileModel(image: entity.image, name: entity.name, website: entity.website)
    }

    public func transformDomainToEntity(domain: ProfileModel?) -> ProfileEntity {
        ProfileEntity(
            image: domain?.image,
            name: domain?.name ?? "",
            website: domain?.website ?? ""
        )
    }
}
