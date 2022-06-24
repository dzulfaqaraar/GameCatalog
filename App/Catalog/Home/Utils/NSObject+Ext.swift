//
//  NSObject+Ext.swift
//  Catalog
//
//  Created by Dzulfaqar on 22/06/22.
//

import IGListKit

extension NSObject: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}
