//
//  GenreDataView.swift
//  Catalog
//
//  Created by Dzulfaqar on 03/06/22.
//

import Common
import UIKit

class GenreDataView: UIView {
    private var listGenre: [GenreModel] = []
    var callback: ((GenreModel?) -> Void)?
    var urlAllGames: String?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumLineSpacing = 5
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: String(describing: GenreCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: GenreCollectionViewCell.description()
        )
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func build(data list: [GenreModel]) {
        listGenre = list

        collectionView.reloadData()
    }
}

extension GenreDataView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        listGenre.count + 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.description(), for: indexPath
        ) as? GenreCollectionViewCell {
            cell.callback = callback

            if indexPath.row == 0 {
                cell.allGames(url: urlAllGames)
            } else {
                let data = listGenre[indexPath.row - 1]
                cell.setup(with: data)
            }
            return cell
        }

        return UICollectionViewCell()
    }
}
