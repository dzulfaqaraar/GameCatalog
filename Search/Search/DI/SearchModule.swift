//
//  SearchModule.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Common
import Core
import Foundation

struct SearchRemoteDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(NetworkManager.self)
            .sharedInScope()
            .to(factory: NetworkManager.init)

        binder.bind(SearchRemoteDataSource.self)
            .sharedInScope()
            .to(factory: SearchRemoteDataSource.init)
    }
}

struct SearchMapperModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(GameTransformer.self)
            .sharedInScope()
            .to(factory: GameTransformer.init)
    }
}

struct SearchRepositoryModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: SearchRemoteDataSourceModule.self)
        binder.include(module: SearchMapperModule.self)

        binder.bind(SearchRepository<SearchRemoteDataSource, GameTransformer>.self)
            .sharedInScope()
            .to(factory: SearchRepository<SearchRemoteDataSource, GameTransformer>.init)
    }
}

public struct SearchUseCaseModule: Module {
    public static func configure(binder: Binder<Singleton>) {
        binder.include(module: SearchRepositoryModule.self)

        binder.bind(SearchUseCase<SearchRepository<SearchRemoteDataSource, GameTransformer>>.self)
            .sharedInScope()
            .to(factory: SearchUseCase.init)
        binder.bind(Interactor<[String: Any?], [GameModel], SearchRepository<SearchRemoteDataSource, GameTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)
    }
}

public struct SearchModule: Module {
    public static func configure(binder: Binder<Singleton>) {
        binder.include(module: SearchUseCaseModule.self)

        binder.bind(SearchViewModel.self)
            .sharedInScope()
            .to(factory: SearchViewModel.init)
    }
}
