//
//  FavoriteCollectionViewCell.swift
//  Catalog
//
//  Created by Dzulfaqar on 07/06/22.
//

import Common
import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet var parentView: UIView!
    @IBOutlet var backgroundCover: UIView!
    @IBOutlet var favoriteImage: UIImageView!
    @IBOutlet var favoriteTitle: UILabel!
    @IBOutlet var favoriteRelease: UILabel!
    @IBOutlet var favoriteRating: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView!

    var callback: ((Int) -> Void)?
    var data: FavoriteModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteImage.layer.cornerRadius = 20

        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemSelected(sender:)))
        parentView.addGestureRecognizer(tapGesture)
    }

    @objc func itemSelected(sender _: UITapGestureRecognizer) {
        if let id = data?.id {
            callback?(Int(id))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteImage.image = nil
        favoriteTitle.text = ""
        favoriteRelease.text = ""
        favoriteRating.text = ""
        backgroundCover.backgroundColor = nil
    }

    func setup(with data: FavoriteModel) {
        self.data = data

        favoriteImage.load(url: data.image) { [weak self] in
            self?.showData(data)
        }
    }

    private func showData(_ data: FavoriteModel) {
        favoriteTitle.text = data.name

        favoriteRelease.text = data.released?.releasedDate()
        favoriteRating.text = data.rating?.ratingFormatted()

        loadingView.stopAnimating()
        loadingView.alpha = 0

        backgroundCover.layer.cornerRadius = 20
        backgroundCover.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
}
