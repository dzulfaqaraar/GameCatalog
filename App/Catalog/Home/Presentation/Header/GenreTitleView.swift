//
//  GenreTitleView.swift
//  Catalog
//
//  Created by Dzulfaqar on 04/06/22.
//

import Common
import UIKit

class GenreTitleView: UIView {
    private lazy var genreView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "genres_title".localized()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var favoriteView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "favorites_title".localized()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.isUserInteractionEnabled = true
        return label
    }()

    var callback: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onGenresPressed(sender _: UITapGestureRecognizer) {
        callback?(false)
    }

    @objc func onFavoritePressed(sender _: UITapGestureRecognizer) {
        callback?(true)
    }

    private func setupView() {
        genreView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.centerXAnchor.constraint(equalTo: genreView.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: genreView.centerYAnchor)
        ])
        addSubview(genreView)
        NSLayoutConstraint.activate([
            genreView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            genreView.topAnchor.constraint(equalTo: topAnchor),
            genreView.bottomAnchor.constraint(equalTo: bottomAnchor),
            genreView.widthAnchor.constraint(equalToConstant: 100)
        ])

        favoriteView.addSubview(favoriteLabel)
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteLabel.centerXAnchor.constraint(equalTo: favoriteView.centerXAnchor),
            favoriteLabel.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor)
        ])
        addSubview(favoriteView)
        NSLayoutConstraint.activate([
            favoriteView.leftAnchor.constraint(equalTo: genreView.rightAnchor, constant: 10),
            favoriteView.topAnchor.constraint(equalTo: topAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoriteView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupGesture() {
        let tapGestureGenres = UITapGestureRecognizer(target: self, action: #selector(onGenresPressed(sender:)))
        genreLabel.addGestureRecognizer(tapGestureGenres)

        let tapGestureFavorites = UITapGestureRecognizer(target: self, action: #selector(onFavoritePressed(sender:)))
        favoriteLabel.addGestureRecognizer(tapGestureFavorites)
    }

    func changeSelected(_ isFavorited: Bool) {
        if isFavorited {
            genreView.backgroundColor = .clear
            genreLabel.textColor = .black

            favoriteView.backgroundColor = .black.withAlphaComponent(0.8)
            favoriteLabel.textColor = .white
        } else {
            genreView.backgroundColor = .black.withAlphaComponent(0.8)
            genreLabel.textColor = .white

            favoriteView.backgroundColor = .clear
            favoriteLabel.textColor = .black
        }
    }
}
