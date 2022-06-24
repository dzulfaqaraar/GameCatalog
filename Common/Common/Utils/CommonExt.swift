//
//  CommonExt.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import SDWebImage
import SwiftUI

public extension UIImageView {
    func load(url: String?, defaultImage: String? = nil, callback: (() -> Void)? = nil) {
        let url = URL(string: url ?? "")
        let placeholderImage = UIImage(systemName: defaultImage ?? "exclamationmark.icloud.fill")

        contentMode = .scaleAspectFit
        sd_setImage(with: url, placeholderImage: placeholderImage) { _, _, _, _ in
            self.contentMode = .scaleAspectFill
            callback?()
        }
    }
}

public extension String {
    func toDate() -> String? {
        let dateFormatterFrom = DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd"

        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "MMM d, yyyy"

        if let date = dateFormatterFrom.date(from: self) {
            return dateFormatterTo.string(from: date)
        }

        return nil
    }

    func releasedDate() -> String {
        var releaseText = "release_date_label".localized()
        if let date = toDate() {
            releaseText += "\n\(date)"
        } else {
            releaseText += "-"
        }
        let releaseAttr = NSMutableAttributedString(string: releaseText)
        if let rangeString = releaseText.range(of: "release_date_label".localized()) {
            let range = NSRange(rangeString, in: releaseText)

            releaseAttr.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ], range: range)
        }

        return releaseAttr.string
    }
}

public extension Double {
    func ratingFormatted() -> String {
        let ratingText = "\("rating_label".localized()) \(self)"
        let ratingAttr = NSMutableAttributedString(string: ratingText)
        if let rangeString = ratingText.range(of: "rating_label".localized()) {
            let range = NSRange(rangeString, in: ratingText)

            ratingAttr.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ], range: range)
        }
        return ratingAttr.string
    }
}
