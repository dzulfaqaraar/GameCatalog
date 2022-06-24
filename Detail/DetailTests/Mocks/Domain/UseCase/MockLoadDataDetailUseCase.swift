//
//  MockLoadDataDetailUseCase.swift
//  DetailTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Common
import Core
import Detail

public class MockLoadDataDetailUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == GameModel? {
    public typealias Request = Int
    public typealias Response = GameModel?

    var isSuccess = true
    var responseValue: GameModel?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: Int?) -> AnyPublisher<GameModel?, Error> {
        functionWasCalled = true
        return Future<GameModel?, Error> { completion in
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
