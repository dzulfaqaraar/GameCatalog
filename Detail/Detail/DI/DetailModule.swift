//
//  DetailModule.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Common
import Core
import Foundation

struct DetailLocaleDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(DetailLocaleDataSource.self)
            .sharedInScope()
            .to(factory: DetailLocaleDataSource.init)
    }
}

struct DetailRemoteDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(NetworkManager.self)
            .sharedInScope()
            .to(factory: NetworkManager.init)

        binder.bind(DetailRemoteDataSource.self)
            .sharedInScope()
            .to(factory: DetailRemoteDataSource.init)
    }
}

struct DetailMapperModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(GameTransformer.self)
            .sharedInScope()
            .to(factory: GameTransformer.init)
        binder.bind(FavoriteTransformer.self)
            .sharedInScope()
            .to(factory: FavoriteTransformer.init)
    }
}

struct DetailRepositoryModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: DetailLocaleDataSourceModule.self)
        binder.include(module: DetailRemoteDataSourceModule.self)
        binder.include(module: DetailMapperModule.self)

        binder.bind(GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.self)
            .sharedInScope()
            .to(factory: GetFavoriteDetailRepository.init)

        binder.bind(InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>.self)
            .sharedInScope()
            .to(factory: InsertFavoriteDetailRepository.init)

        binder.bind(DeleteFavoriteDetailRepository<DetailLocaleDataSource>.self)
            .sharedInScope()
            .to(factory: DeleteFavoriteDetailRepository.init)

        binder.bind(LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>.self)
            .sharedInScope()
            .to(factory: LoadDataDetailRepository.init)
    }
}

struct DetailUseCaseModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: DetailRepositoryModule.self)

        binder.bind(GetFavoriteDetailUseCase<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
            .sharedInScope()
            .to(factory: GetFavoriteDetailUseCase.init)
        binder.bind(Interactor<Int, [FavoriteModel], GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)

        binder.bind(InsertFavoriteDetailUseCase<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
            .sharedInScope()
            .to(factory: InsertFavoriteDetailUseCase.init)
        binder.bind(Interactor<FavoriteModel, Bool, InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)

        binder.bind(DeleteFavoriteDetailUseCase<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>.self)
            .sharedInScope()
            .to(factory: DeleteFavoriteDetailUseCase.init)
        binder.bind(Interactor<Int, Bool, DeleteFavoriteDetailRepository<DetailLocaleDataSource>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)

        binder.bind(LoadDataDetailUseCase<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>.self)
            .sharedInScope()
            .to(factory: LoadDataDetailUseCase.init)
        binder.bind(Interactor<Int, GameModel?, LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)
    }
}

public struct DetailModule: Module {
    public static func configure(binder: Binder<Singleton>) {
        binder.include(module: DetailUseCaseModule.self)
    }
}
