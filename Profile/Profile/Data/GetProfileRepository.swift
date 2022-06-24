//
//  GetProfileRepository.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Core
import Foundation

public struct GetProfileRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Request == Int,
    Locale.Response == ProfileEntity,
    Transformer.Response == Any,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel {
    public typealias Request = Int
    public typealias Response = ProfileModel

    private let locale: Provider<Locale>
    private let mapper: Provider<Transformer>

    public init(
        locale: Provider<Locale>,
        mapper: Provider<Transformer>
    ) {
        self.locale = locale
        self.mapper = mapper
    }

    public func execute(request: Int?) -> AnyPublisher<ProfileModel, Error> {
        locale.get().get(id: request)
            .map { entity in
                mapper.get().transformEntityToDomain(entity: entity)
            }.eraseToAnyPublisher()
    }
}
