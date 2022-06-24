//
//  InsertFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class InsertFavoriteDetailUseCase<R: Repository>: UseCase
    where R.Request == FavoriteModel,
    R.Response == Bool {
    public typealias Request = FavoriteModel
    public typealias Response = Bool

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: FavoriteModel?) -> AnyPublisher<Bool, Error> {
        repository.get().execute(request: request)
    }
}
