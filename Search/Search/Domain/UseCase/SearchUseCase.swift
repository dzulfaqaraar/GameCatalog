//
//  SearchUseCase.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class SearchUseCase<R: Repository>: UseCase
    where R.Request == [String: Any?],
    R.Response == [GameModel] {
    public typealias Request = [String: Any?]
    public typealias Response = [GameModel]

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: [String: Any?]?) -> AnyPublisher<[GameModel], Error> {
        repository.get().execute(request: request)
    }
}
