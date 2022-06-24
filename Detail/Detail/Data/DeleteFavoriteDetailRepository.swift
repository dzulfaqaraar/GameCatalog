//
//  DeleteFavoriteDetailRepository.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public struct DeleteFavoriteDetailRepository<Locale: LocaleDataSource>: Repository
    where Locale.Request == Int {
    public typealias Request = Int
    public typealias Response = Bool

    private let locale: Provider<Locale>

    public init(locale: Provider<Locale>) {
        self.locale = locale
    }

    public func execute(request: Int?) -> AnyPublisher<Bool, Error> {
        if let request = request {
            return locale.get().delete(id: request)
        }

        return Future<Bool, Error> { completion in
            completion(.failure(DatabaseError.requestFailed))
        }.eraseToAnyPublisher()
    }
}
