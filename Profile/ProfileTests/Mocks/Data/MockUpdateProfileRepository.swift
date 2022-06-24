//
//  MockUpdateProfileRepository.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import Combine
import Common
import Core
import Profile

class MockUpdateProfileRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Response == ProfileEntity,
    Transformer.Response == Any,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel {
    typealias Request = ProfileModel
    typealias Response = Bool

    var isSuccess = true
    var responseValue: Bool?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    func execute(request _: ProfileModel?) -> AnyPublisher<Bool, Error> {
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
