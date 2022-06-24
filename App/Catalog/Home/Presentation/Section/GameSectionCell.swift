//
//  GameSectionCell.swift
//  Catalog
//
//  Created by Dzulfaqar on 04/06/22.
//

import Common
import UIKit

class GameSectionCell: UICollectionViewCell {
    private var listGame: [GameModel] = []
    var callback: ((Int) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        let space: CGFloat = flowLayout.minimumInteritemSpacing +
            flowLayout.sectionInset.left +
            flowLayout.sectionInset.right
        let width = (contentView.bounds.width - space - 40) / 2.0
        flowLayout.itemSize = CGSize(width: width, height: 300)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: String(describing: GameCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: GameCollectionViewCell.description()
        )
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func build(data list: [GameModel]) {
        listGame = list

        collectionView.reloadData()
    }
}

extension GameSectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        listGame.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCollectionViewCell.description(), for: indexPath
        ) as? GameCollectionViewCell {
            let data = listGame[indexPath.row]
            cell.callback = callback
            cell.setup(with: data)
            return cell
        }

        return UICollectionViewCell()
    }
}
