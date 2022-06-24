//
//  SearchRemoteDataSource.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class SearchRemoteDataSource: RemoteDataSource {
    public typealias Request = [String: Any?]
    public typealias Response = GameResponse?

    private var network: Provider<NetworkManager>

    public init(network: Provider<NetworkManager>) {
        self.network = network
    }

    public func execute(request: [String: Any?]?) -> AnyPublisher<GameResponse?, Error> {
        let url = NetworkEndpoint.games
        return network.get().performRequest(url: url, params: request)
    }
}
