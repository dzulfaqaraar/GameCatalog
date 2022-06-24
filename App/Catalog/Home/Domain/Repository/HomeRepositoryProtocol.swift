//
//  HomeRepositoryProtocol.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common
import Foundation

protocol HomeRepositoryProtocol {
    // MARK: - LocaleDataSource

    func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error>

    // MARK: - RemoteDataSource

    func loadAllGames(param: [String: Any?], withGenres: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error>
}
