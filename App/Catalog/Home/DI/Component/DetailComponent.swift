//
//  DetailComponent.swift
//  Catalog
//
//  Created by Dzulfaqar on 14/06/22.
//

import Cleanse
import Common
import Detail
import Foundation

struct DetailComponent: RootComponent {
    typealias GetType = GetFavoriteDetailUseCase<GetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
    typealias InsertType = InsertFavoriteDetailUseCase<InsertFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>
    typealias DeleteType = DeleteFavoriteDetailUseCase<DeleteFavoriteDetailRepository<DetailLocaleDataSource>>
    typealias LoadType = LoadDataDetailUseCase<LoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>

    typealias Root = DetailViewModel<GetType, InsertType, DeleteType, LoadType>

    static func configureRoot(binder bind: ReceiptBinder<Root>) -> BindingReceipt<Root> {
        return bind.to(factory: DetailViewModel.init)
    }

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: DetailModule.self)
    }
}
