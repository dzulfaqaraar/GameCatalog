//
//  GamesInteractor.swift
//  Catalog
//
//  Created by Dzulfaqar on 12/06/22.
//

import Cleanse
import Combine
import Common
import Foundation

class GamesInteractor {
    private let repository: Provider<HomeRepositoryProtocol>

    required init(repository: Provider<HomeRepositoryProtocol>) {
        self.repository = repository
    }
}

extension GamesInteractor: GamesUseCase {
    func loadAllGames(param: [String: Any?], withGenres: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error> {
        return repository.get().loadAllGames(param: param, withGenres: withGenres)
    }
}
