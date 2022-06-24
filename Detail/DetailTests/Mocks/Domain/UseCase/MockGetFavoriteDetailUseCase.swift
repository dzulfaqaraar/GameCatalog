//
//  MockGetFavoriteDetailUseCase.swift
//  DetailTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Common
import Core
import Detail

public class MockGetFavoriteDetailUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == [FavoriteModel] {
    public typealias Request = Int
    public typealias Response = [FavoriteModel]

    var isSuccess = true
    var responseValue: [FavoriteModel]?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: Int?) -> AnyPublisher<[FavoriteModel], Error> {
        functionWasCalled = true
        return Future<[FavoriteModel], Error> { completion in
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
