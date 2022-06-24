//
//  SearchCollectionViewCell.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Common
import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet var parentView: UIView!
    @IBOutlet var backgroundCover: UIView!
    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var gameTitle: UILabel!
    @IBOutlet var gameRelease: UILabel!
    @IBOutlet var gameRating: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView!

    var callback: ((Int) -> Void)?
    var data: GameModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        gameImageView.layer.cornerRadius = 20

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemSelected(sender:)))
        parentView.addGestureRecognizer(tapGesture)
    }

    @objc func itemSelected(sender _: UITapGestureRecognizer) {
        if let id = data?.id {
            callback?(id)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
        gameTitle.text = ""
        gameRelease.text = ""
        gameRating.text = ""
        backgroundCover.backgroundColor = nil
    }

    func setup(with data: GameModel) {
        self.data = data

        gameImageView.load(url: data.image) { [weak self] in
            self?.showData(data)
        }
    }

    private func showData(_ data: GameModel) {
        gameTitle.text = data.name
        gameRelease.text = data.released?.releasedDate()
        gameRating.text = data.rating?.ratingFormatted()

        loadingView.stopAnimating()
        loadingView.alpha = 0

        backgroundCover.layer.cornerRadius = 20
        backgroundCover.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
    }
}
