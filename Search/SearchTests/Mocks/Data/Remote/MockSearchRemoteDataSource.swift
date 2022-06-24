//
//  MockSearchRemoteDataSource.swift
//  SearchTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Common
import Core
import Search
import XCTest

class MockSearchRemoteDataSource: RemoteDataSource {
    typealias Request = [String: Any?]
    typealias Response = GameResponse?

    var isSuccess = true
    var responseValue: GameResponse?
    var errorValue: Error?

    func execute(request _: [String: Any?]?) -> AnyPublisher<GameResponse?, Error> {
        return Future<GameResponse?, Error> { completion in
            if self.isSuccess {
                completion(.success(self.responseValue))
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }
}
