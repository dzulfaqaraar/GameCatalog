//
//  MockGetProfileRepository.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import Combine
import Common
import Core
import Profile

public class MockGetProfileRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Request == Int,
    Locale.Response == ProfileEntity,
    Transformer.Response == Any,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel {
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
