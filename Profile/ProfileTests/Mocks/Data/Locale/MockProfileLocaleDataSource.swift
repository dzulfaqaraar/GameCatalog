//
//  MockProfileLocaleDataSource.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Combine
import Common
import Core
import Profile
import XCTest

class MockProfileLocaleDataSource<T>: LocaleDataSource {
    typealias Request = Int
    typealias Response = ProfileEntity

    var isSuccess = true
    var responseValue: T?
    var errorValue: Error?

    func list(request _: Int?) -> AnyPublisher<[ProfileEntity], Error> {
        fatalError()
    }

    func get(id _: Int?) -> AnyPublisher<ProfileEntity, Error> {
        return Future<ProfileEntity, Error> { completion in
            if self.isSuccess {
                if let responseValue = self.responseValue as? ProfileEntity {
                    completion(.success(responseValue))
                }
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }

    func add(data _: [ProfileEntity]) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    func update(data _: ProfileEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if self.isSuccess {
                if let responseValue = self.responseValue as? Bool {
                    completion(.success(responseValue))
                }
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }

    func delete(id _: Int) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
}
