//
//  Repository.swift
//  Core
//
//  Created by Dzulfaqar on 18/06/22.
//

import Combine
import Foundation

public protocol Repository {
    associatedtype Request
    associatedtype Response

    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
