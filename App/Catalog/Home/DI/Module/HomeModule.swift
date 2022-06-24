//
//  HomeModule.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Common
import Foundation

struct HomeLocaleDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(HomeLocaleDataSourceProtocol.self)
            .sharedInScope()
            .to(factory: HomeLocaleDataSource.init)
    }
}

struct HomeRemoteDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(NetworkManager.self)
            .sharedInScope()
            .to(factory: NetworkManager.init)

        binder.bind(HomeRemoteDataSourceProtocol.self)
            .sharedInScope()
            .to(factory: HomeRemoteDataSource.init)
    }
}

struct HomeMapperModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(GenreTransformer.self)
            .sharedInScope()
            .to(factory: GenreTransformer.init)
        binder.bind(GameTransformer.self)
            .sharedInScope()
            .to(factory: GameTransformer.init)
        binder.bind(FavoriteTransformer.self)
            .sharedInScope()
            .to(factory: FavoriteTransformer.init)
    }
}

struct HomeRepositoryModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: HomeLocaleDataSourceModule.self)
        binder.include(module: HomeRemoteDataSourceModule.self)
        binder.include(module: HomeMapperModule.self)

        binder.bind(HomeRepositoryProtocol.self)
            .sharedInScope()
            .to(factory: HomeRepository.init)
    }
}

struct HomeUseCaseModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: HomeRepositoryModule.self)

        binder.bind(GamesUseCase.self)
            .sharedInScope()
            .to(factory: GamesInteractor.init)

        binder.bind(FavoriteUseCase.self)
            .sharedInScope()
            .to(factory: FavoriteInteractor.init)
    }
}

struct HomeModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: HomeUseCaseModule.self)

        binder.bind(HomeViewModel.self)
            .sharedInScope()
            .to(factory: HomeViewModel.init)
    }
}
