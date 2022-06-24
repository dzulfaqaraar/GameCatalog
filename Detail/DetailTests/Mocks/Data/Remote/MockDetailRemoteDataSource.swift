//
//  MockDetailRemoteDataSource.swift
//  DetailTests
//
//  Created by Dzulfaqar on 22/06/22.
//

import Combine
import Common
import Core
import Detail
import XCTest

class MockDetailRemoteDataSource: RemoteDataSource {
    typealias Request = Int
    typealias Response = GameResultResponse?

    var isSuccess = true
    var responseValue: GameResultResponse?
    var errorValue: Error?

    func execute(request _: Int?) -> AnyPublisher<GameResultResponse?, Error> {
        return Future<GameResultResponse?, Error> { completion in
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
