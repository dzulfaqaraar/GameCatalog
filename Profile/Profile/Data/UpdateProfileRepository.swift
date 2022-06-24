//
//  UpdateProfileRepository.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Core
import Foundation

public struct UpdateProfileRepository<Locale: LocaleDataSource, Transformer: Mapper>: Repository
    where Locale.Response == ProfileEntity,
    Transformer.Response == Any,
    Transformer.Entity == ProfileEntity,
    Transformer.Domain == ProfileModel {
    public typealias Request = ProfileModel
    public typealias Response = Bool

    private let locale: Provider<Locale>
    private let mapper: Provider<Transformer>

    public init(
        locale: Provider<Locale>,
        mapper: Provider<Transformer>
    ) {
        self.locale = locale
        self.mapper = mapper
    }

    public func execute(request: ProfileModel?) -> AnyPublisher<Bool, Error> {
        locale.get().update(
            data: mapper.get().transformDomainToEntity(domain: request)
        )
    }
}
