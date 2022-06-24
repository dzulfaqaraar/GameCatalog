//
//  MockGameTransformer.swift
//  DetailTests
//
//  Created by Dzulfaqar on 22/06/22.
//

import Common
import Core

class MockGameTransformer: Mapper {
    typealias Response = [GameResultResponse]
    typealias Entity = Any
    typealias Domain = [GameModel]

    private var functionWasCalled = false
    var responseDomain: [GameModel] = []

    func verify() -> Bool {
        return functionWasCalled
    }

    func transformResponseToDomain(response _: [GameResultResponse]) -> [GameModel] {
        functionWasCalled = true
        return responseDomain
    }

    func transformResponseToEntity(response _: [GameResultResponse]) -> Any {
        fatalError()
    }

    func transformEntityToDomain(entity _: Any) -> [GameModel] {
        fatalError()
    }

    func transformDomainToEntity(domain _: [GameModel]?) -> Any {
        fatalError()
    }
}
