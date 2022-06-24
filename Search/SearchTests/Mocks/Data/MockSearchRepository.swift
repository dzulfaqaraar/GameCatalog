//
//  MockSearchRepository.swift
//  SearchTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common
import Core
import Search

public class MockSearchRepository<Remote: RemoteDataSource, Transformer: Mapper>: Repository
    where Remote.Request == [String: Any?],
    Remote.Response == GameResponse?,
    Transformer.Response == [GameResultResponse],
    Transformer.Entity == Any,
    Transformer.Domain == [GameModel] {
    public typealias Request = [String: Any?]
    public typealias Response = [GameModel]

    var isSuccess = true
    var responseValue: [GameModel]?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: [String: Any?]?) -> AnyPublisher<[GameModel], Error> {
        functionWasCalled = true
        return Future<[GameModel], Error> { completion in
            if self.isSuccess {
                if let responseValue = self.responseValue {
                    completion(.success(responseValue))
                }
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }
}
