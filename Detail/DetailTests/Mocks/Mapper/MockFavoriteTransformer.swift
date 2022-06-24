//
//  MockFavoriteTransformer.swift
//  DetailTests
//
//  Created by Dzulfaqar on 22/06/22.
//

import Common
import Core

class MockFavoriteTransformer: Mapper {
    typealias Response = Any
    typealias Entity = [FavoriteEntity]
    typealias Domain = [FavoriteModel]

    init() {}

    private var functionWasCalled = false
    var responseEntity: [FavoriteEntity] = []
    var responseDomain: [FavoriteModel] = []

    func verify() -> Bool {
        return functionWasCalled
    }

    func transformResponseToDomain(response _: Any) -> [FavoriteModel] {
        fatalError()
    }

    func transformResponseToEntity(response _: Any) -> [FavoriteEntity] {
        fatalError()
    }

    func transformEntityToDomain(entity _: [FavoriteEntity]) -> [FavoriteModel] {
        functionWasCalled = true
        return responseDomain
    }

    func transformDomainToEntity(domain _: [FavoriteModel]?) -> [FavoriteEntity] {
        functionWasCalled = true
        return responseEntity
    }
}
