//
//  Constants.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public let commonBundle = Bundle(identifier: "com.dzulfaqar.catalog.Common") ?? Bundle.main
public let searchBundle = Bundle(identifier: "com.dzulfaqar.catalog.Search") ?? Bundle.main
public let profileBundle = Bundle(identifier: "com.dzulfaqar.catalog.Profile") ?? Bundle.main

public extension String {
    func localized(value: String = "") -> String {
        NSLocalizedString(
            self,
            tableName: nil,
            bundle: commonBundle,
            value: value,
            comment: ""
        )
    }
}
