//
//  GameTransformer.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Core
import Foundation

public struct GameTransformer: Mapper {
    public typealias Response = [GameResultResponse]
    public typealias Entity = Any
    public typealias Domain = [GameModel]

    public init() {}

    public func transformResponseToDomain(response: [GameResultResponse]) -> [GameModel] {
        return response.map { data in
            transformResponseToDomain(response: data)
        }
    }

    public func transformResponseToDomain(response data: GameResultResponse) -> GameModel {
        return GameModel(
            id: data.id,
            rating: data.rating,
            name: data.name,
            image: data.backgroundImage,
            released: data.released,
            descriptionRaw: data.descriptionRaw,
            developersName: data.developers?.map { $0.name ?? "" }.joined(separator: ", "),
            publishersName: data.publishers?.map { $0.name ?? "" }.joined(separator: ", "),
            genres: data.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        )
    }

    public func transformResponseToEntity(response _: [GameResultResponse]) -> Any {
        fatalError()
    }

    public func transformEntityToDomain(entity _: Any) -> [GameModel] {
        fatalError()
    }

    public func transformDomainToEntity(domain _: [GameModel]?) -> Any {
        fatalError()
    }
}
