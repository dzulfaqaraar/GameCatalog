//
//  HomeComponent.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Foundation

struct HomeComponent: RootComponent {
    typealias Root = HomeViewController

    static func configureRoot(binder bind: ReceiptBinder<HomeViewController>) -> BindingReceipt<HomeViewController> {
        return bind.to(factory: HomeViewController.init)
    }

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: HomeModule.self)
    }
}
