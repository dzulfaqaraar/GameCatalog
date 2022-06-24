//
//  ProfileComponent.swift
//  Catalog
//
//  Created by Dzulfaqar on 14/06/22.
//

import Cleanse
import Foundation
import Profile

struct ProfileComponent: RootComponent {
    typealias Root = ProfileViewController

    static func configureRoot(binder bind: ReceiptBinder<ProfileViewController>) -> BindingReceipt<ProfileViewController> {
        return bind.to(factory: ProfileViewController.init)
    }

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: ProfileModule.self)
    }
}
