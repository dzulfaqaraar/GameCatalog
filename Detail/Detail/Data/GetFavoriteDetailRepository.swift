//
//  GetFavoriteDetailRepository.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public struct GetFavoriteDetailRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Response == FavoriteEntity,
    Transformer.Response == Any,
    Transformer.Entity == [FavoriteEntity],
    Transformer.Domain == [FavoriteModel] {
    public typealias Request = Int
    public typealias Response = [FavoriteModel]

    private let locale: Provider<Locale>
    private let mapper: Provider<Transformer>

    public init(
        locale: Provider<Locale>,
        mapper: Provider<Transformer>
    ) {
        self.locale = locale
        self.mapper = mapper
    }

    public func execute(request: Int?) -> AnyPublisher<[FavoriteModel], Error> {
        locale.get().get(id: request)
            .map { entity in
                mapper.get().transformEntityToDomain(entity: [entity])
            }.eraseToAnyPublisher()
    }
}
