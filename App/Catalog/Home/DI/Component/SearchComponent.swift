//
//  SearchComponent.swift
//  Catalog
//
//  Created by Dzulfaqar on 14/06/22.
//

import Cleanse
import Foundation
import Search

struct SearchComponent: RootComponent {
    typealias Root = SearchViewController

    static func configureRoot(binder bind: ReceiptBinder<SearchViewController>) -> BindingReceipt<SearchViewController> {
        return bind.to(factory: SearchViewController.init)
    }

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: SearchModule.self)
    }
}
