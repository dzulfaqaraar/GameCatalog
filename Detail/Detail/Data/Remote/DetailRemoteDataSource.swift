//
//  DetailRemoteDataSource.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class DetailRemoteDataSource: RemoteDataSource {
    public typealias Request = Int
    public typealias Response = GameResultResponse?

    private var network: Provider<NetworkManager>

    public init(network: Provider<NetworkManager>) {
        self.network = network
    }

    public func execute(request: Int?) -> AnyPublisher<GameResultResponse?, Error> {
        let url = "\(NetworkEndpoint.detail)\(request ?? -1)"
        return network.get().performRequest(url: url)
    }
}
