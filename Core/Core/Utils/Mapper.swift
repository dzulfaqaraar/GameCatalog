//
//  Mapper.swift
//  Core
//
//  Created by Dzulfaqar on 18/06/22.
//

import Foundation

public protocol Mapper {
    associatedtype Response
    associatedtype Entity
    associatedtype Domain

    func transformResponseToDomain(response: Response) -> Domain
    func transformResponseToEntity(response: Response) -> Entity
    func transformEntityToDomain(entity: Entity) -> Domain
    func transformDomainToEntity(domain: Domain?) -> Entity
}
