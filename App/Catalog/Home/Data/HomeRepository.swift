//
//  HomeRepository.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Foundation

final class HomeRepository: NSObject {
    private let locale: Provider<HomeLocaleDataSourceProtocol>
    private let remote: Provider<HomeRemoteDataSourceProtocol>
    private let genreMapper: Provider<GenreTransformer>
    private let gameMapper: Provider<GameTransformer>
    private let favoriteMapper: Provider<FavoriteTransformer>

    init(
        locale: Provider<HomeLocaleDataSourceProtocol>,
        remote: Provider<HomeRemoteDataSourceProtocol>,
        genreMapper: Provider<GenreTransformer>,
        gameMapper: Provider<GameTransformer>,
        favoriteMapper: Provider<FavoriteTransformer>
    ) {
        self.locale = locale
        self.remote = remote
        self.genreMapper = genreMapper
        self.gameMapper = gameMapper
        self.favoriteMapper = favoriteMapper
    }
}

extension HomeRepository: HomeRepositoryProtocol {
    // MARK: - LocaleDataSource

    func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error> {
        return locale.get().getAllFavorite()
            .map { self.favoriteMapper.get().transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
    }

    // MARK: - RemoteDataSource

    func loadAllGames(param: [String: Any?], withGenres: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error> {
        if withGenres {
            return loadAllGenres()
                .flatMap { listGenre -> AnyPublisher<([GenreModel], [GameModel]), Error> in

                    self.remote.get().loadAllGames(param: param)
                        .map {
                            let listGame = self.gameMapper.get().transformResponseToDomain(response: $0?.results ?? [])
                            return (listGenre, listGame)
                        }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return remote.get().loadAllGames(param: param)
                .map {
                    let listGame = self.gameMapper.get().transformResponseToDomain(response: $0?.results ?? [])
                    return ([], listGame)
                }
                .eraseToAnyPublisher()
        }
    }

    private func loadAllGenres() -> AnyPublisher<[GenreModel], Error> {
        return locale.get().getAllGenres()
            .flatMap { genresEntity -> AnyPublisher<[GenreModel], Error> in
                if genresEntity.isEmpty {
                    return self.remote.get().loadGenres()
                        .flatMap { genresResponse -> AnyPublisher<[GenreModel], Error> in
                            let listGenres = self.genreMapper.get().transformResponseToEntity(response: genresResponse?.results ?? [])

                            return self.locale.get().insertGenres(from: listGenres)
                                .flatMap { _ in
                                    self.loadSavedGenres()
                                }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.loadSavedGenres()
                }
            }
            .eraseToAnyPublisher()
    }

    private func loadSavedGenres() -> AnyPublisher<[GenreModel], Error> {
        return locale.get().getAllGenres()
            .map { self.genreMapper.get().transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
    }
}
