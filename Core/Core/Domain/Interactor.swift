//
//  Interactor.swift
//  Core
//
//  Created by Dzulfaqar on 18/06/22.
//

import Combine
import Foundation

public struct Interactor<Request, Response, R: Repository>: UseCase where R.Request == Request, R.Response == Response {
    private let repository: R

    public init(repository: R) {
        self.repository = repository
    }

    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        repository.execute(request: request)
    }
}
