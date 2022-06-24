//
//  DeleteFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Core
import Foundation

public class DeleteFavoriteDetailUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == Bool {
    public typealias Request = Int
    public typealias Response = Bool

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: Int?) -> AnyPublisher<Bool, Error> {
        repository.get().execute(request: request)
    }
}
