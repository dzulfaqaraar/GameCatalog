//
//  MockInsertFavoriteDetailRepository.swift
//  DetailTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import Combine
import Common
import Core
import Detail

public class MockInsertFavoriteDetailRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Response == FavoriteEntity,
    Transformer.Response == Any,
    Transformer.Entity == [FavoriteEntity],
    Transformer.Domain == [FavoriteModel] {
    public typealias Request = FavoriteModel
    public typealias Response = Bool

    var isSuccess = true
    var responseValue: Bool?
    var errorValue: Error?
    var functionWasCalled = false

    func verify() -> Bool {
        return functionWasCalled
    }

    public func execute(request _: FavoriteModel?) -> AnyPublisher<Bool, Error> {
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
