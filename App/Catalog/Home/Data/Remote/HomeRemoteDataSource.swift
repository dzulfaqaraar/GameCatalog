//
//  HomeRemoteDataSource.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Foundation

protocol HomeRemoteDataSourceProtocol: AnyObject {
    func loadGenres() -> AnyPublisher<GenreResponse?, Error>
    func loadAllGames(param: [String: Any?]) -> AnyPublisher<GameResponse?, Error>
}

final class HomeRemoteDataSource: NSObject {
    private var network: Provider<NetworkManager>

    init(network: Provider<NetworkManager>) {
        self.network = network
    }
}

extension HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    func loadGenres() -> AnyPublisher<GenreResponse?, Error> {
        let url = NetworkEndpoint.genres
        return network.get().performRequest(url: url)
    }

    func loadAllGames(param: [String: Any?]) -> AnyPublisher<GameResponse?, Error> {
        let url = NetworkEndpoint.games
        return network.get().performRequest(url: url, params: param)
    }
}
