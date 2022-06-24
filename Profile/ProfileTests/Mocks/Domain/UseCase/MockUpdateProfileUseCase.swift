//
//  MockUpdateProfileUseCase.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Core
import Profile

public class MockUpdateProfileUseCase<R: Repository>: UseCase
    where R.Request == ProfileModel,
    R.Response == Bool {
    public typealias Request = ProfileModel
    public typealias Response = Bool

    var isSuccess = true
    var responseValue: Bool?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: ProfileModel?) -> AnyPublisher<Bool, Error> {
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
