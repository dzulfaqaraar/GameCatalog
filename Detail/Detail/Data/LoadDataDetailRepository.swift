//
//  LoadDataDetailRepository.swift
//  Detail
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public struct LoadDataDetailRepository<Remote: RemoteDataSource, Transformer: Mapper>: Repository
    where Remote.Request == Int,
    Remote.Response == GameResultResponse?,
    Transformer.Response == [GameResultResponse],
    Transformer.Entity == Any,
    Transformer.Domain == [GameModel] {
    public typealias Request = Int
    public typealias Response = GameModel?

    private let remote: Provider<Remote>
    private let mapper: Provider<Transformer>

    public init(
        remote: Provider<Remote>,
        mapper: Provider<Transformer>
    ) {
        self.remote = remote
        self.mapper = mapper
    }

    public func execute(request: Int?) -> AnyPublisher<GameModel?, Error> {
        remote.get().execute(request: request)
            .map {
                if let data = $0 {
                    return mapper.get().transformResponseToDomain(response: [data]).first
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
}
