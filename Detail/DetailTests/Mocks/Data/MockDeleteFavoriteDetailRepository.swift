//
//  MockDeleteFavoriteDetailRepository.swift
//  DetailTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import Combine
import Common
import Core
import Detail

public class MockDeleteFavoriteDetailRepository<Locale: LocaleDataSource>: Repository
    where Locale.Request == Int {
    public typealias Request = Int
    public typealias Response = Bool

    var isSuccess = true
    var responseValue: Bool?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: Int?) -> AnyPublisher<Bool, Error> {
        functionWasCalled = true
        return Future<Bool, Error> { completion in
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
