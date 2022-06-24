//
//  GetFavoriteDetailUseCase.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class GetFavoriteDetailUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == [FavoriteModel] {
    public typealias Request = Int
    public typealias Response = [FavoriteModel]

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: Int?) -> AnyPublisher<[FavoriteModel], Error> {
        repository.get().execute(request: request)
    }
}
