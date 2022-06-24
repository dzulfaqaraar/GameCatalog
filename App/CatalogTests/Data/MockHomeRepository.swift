//
//  MockHomeRepository.swift
//  CatalogTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common

@testable import Catalog
class MockHomeRepository<T>: HomeRepositoryProtocol {
    var isSuccess = true
    var responseValue: T?
    var errorValue: Error?

    // MARK: - LocaleDataSource

    func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error> {
        return Future<[FavoriteModel], Error> { completion in
            if self.isSuccess {
                if let responseValue = self.responseValue as? [FavoriteModel] {
                    completion(.success(responseValue))
                }
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }

    // MARK: - RemoteDataSource

    func loadAllGames(param _: [String: Any?], withGenres _: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error> {
        return Future<([GenreModel], [GameModel]), Error> { completion in
            if self.isSuccess {
                if let responseValue = self.responseValue as? ([GenreModel], [GameModel]) {
                    completion(.success(responseValue))
                }
            } else {
                if let errorValue = self.errorValue {
                    completion(.failure(errorValue))
                }
            }
        }.eraseToAnyPublisher()
    }
}
