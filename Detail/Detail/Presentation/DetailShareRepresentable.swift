//
//  DetailShareRepresentable.swift
//  Detail
//
//  Created by Dzulfaqar on 24/06/22.
//

import SwiftUI

struct DetailShareRepresentable: UIViewControllerRepresentable {
    var image: UIImage

    internal init(image: UIImage) {
        self.image = image
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let dataToShare: [Any] = [image]
        return UIActivityViewController(activityItems: dataToShare as [Any], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {

    }
}
