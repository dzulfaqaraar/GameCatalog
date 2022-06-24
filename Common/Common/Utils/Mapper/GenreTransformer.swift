//
//  GenreTransformer.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Core
import Foundation

public struct GenreTransformer: Mapper {
    public typealias Response = [GenreResultResponse]
    public typealias Entity = [GenreEntity]
    public typealias Domain = [GenreModel]

    public init() {}

    public func transformResponseToDomain(response _: [GenreResultResponse]) -> [GenreModel] {
        fatalError()
    }

    public func transformResponseToEntity(response: [GenreResultResponse]) -> [GenreEntity] {
        return response.map { data in
            transformResponseToEntity(response: data)
        }
    }

    public func transformResponseToEntity(response data: GenreResultResponse) -> GenreEntity {
        return GenreEntity(
            id: Int32(data.id ?? -1),
            name: data.name,
            image: data.imageBackground
        )
    }

    public func transformEntityToDomain(entity: [GenreEntity]) -> [GenreModel] {
        return entity.map { data in
            transformEntityToDomain(entity: data)
        }
    }

    public func transformEntityToDomain(entity data: GenreEntity) -> GenreModel {
        return GenreModel(
            id: Int(data.id ?? -1),
            name: data.name,
            image: data.image
        )
    }

    public func transformDomainToEntity(domain _: [GenreModel]?) -> [GenreEntity] {
        fatalError()
    }
}
