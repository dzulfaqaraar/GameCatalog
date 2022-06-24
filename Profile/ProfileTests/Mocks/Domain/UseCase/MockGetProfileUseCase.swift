//
//  MockGetProfileUseCase.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Core
import Profile

public class MockGetProfileUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == ProfileModel {
    public typealias Request = Int
    public typealias Response = ProfileModel

    var isSuccess = true
    var responseValue: ProfileModel?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: Int?) -> AnyPublisher<ProfileModel, Error> {
        functionWasCalled = true
        return Future<ProfileModel, Error> { completion in
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
