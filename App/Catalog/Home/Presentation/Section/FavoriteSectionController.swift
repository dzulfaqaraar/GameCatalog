//
//  FavoriteSectionController.swift
//  Catalog
//
//  Created by Dzulfaqar on 07/06/22.
//

import Common
import IGListKit
import UIKit

class FavoriteSectionModel: NSObject {
    var list: [FavoriteModel] = []

    init(list: [FavoriteModel]) {
        self.list = list
    }
}

class FavoriteSectionController: ListSectionController {
    var favorite: FavoriteSectionModel!
    var callback: ((Int) -> Void)?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Data Provider

extension FavoriteSectionController {
    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at _: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        let width: CGFloat = context.containerSize.width
        let height: CGFloat = context.containerSize.height
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext?.dequeueReusableCell(
            of: FavoriteSectionCell.self, for: self, at: index
        ) as? FavoriteSectionCell {
            cell.callback = callback
            cell.build(data: favorite.list)
            return cell
        }

        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        favorite = object as? FavoriteSectionModel
    }
}
