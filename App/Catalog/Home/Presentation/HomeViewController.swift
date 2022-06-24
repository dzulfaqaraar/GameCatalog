//
//  HomeViewController.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Detail
import IGListKit
import Profile
import Search
import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables: Set<AnyCancellable> = []

    private lazy var loadingView: UIView = {
        var loadingView = UIView()
        loadingView.frame = view.bounds
        loadingView.backgroundColor = .white.withAlphaComponent(0.3)

        var indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        indicatorView.center = loadingView.center

        loadingView.addSubview(indicatorView)

        return loadingView
    }()

    var headerHeightConstraint = NSLayoutConstraint()

    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    lazy var genreTitleView: GenreTitleView = {
        let genreTitleView = GenreTitleView()
        genreTitleView.translatesAutoresizingMaskIntoConstraints = false
        genreTitleView.changeSelected(false)
        return genreTitleView
    }()

    lazy var genreDataView: GenreDataView = {
        let genreDataView = GenreDataView()
        genreDataView.translatesAutoresizingMaskIntoConstraints = false
        return genreDataView
    }()

    lazy var gameTitleView: GameTitleView = {
        let gameTitleView = GameTitleView()
        gameTitleView.translatesAutoresizingMaskIntoConstraints = false
        gameTitleView.setTitle("All Games")
        return gameTitleView
    }()

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        return ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    }()

    private var isGenreViewAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHeaderView()
        setupContentView()
        setupSubscriber()

        loadData()
    }

    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "main_title".localized()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "person.fill"),
                style: .plain,
                target: self,
                action: #selector(showProfile(_:))
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(showSearch(_:))
            )
        ]
    }

    private func setupHeaderView() {
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 210)

        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerHeightConstraint
        ])
    }

    private func setupContentView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    private func setupGenreView() {
        headerHeightConstraint.constant = 210

        headerView.addSubview(genreTitleView)
        NSLayoutConstraint.activate([
            genreTitleView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            genreTitleView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            genreTitleView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            genreTitleView.heightAnchor.constraint(equalToConstant: 30)
        ])
        genreTitleView.callback = { isFavorited in
            if isFavorited {
                self.loadFavorite()
            } else {
                self.loadData()
            }
        }

        headerView.addSubview(genreDataView)
        NSLayoutConstraint.activate([
            genreDataView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            genreDataView.topAnchor.constraint(equalTo: genreTitleView.bottomAnchor, constant: 20),
            genreDataView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            genreDataView.heightAnchor.constraint(equalToConstant: 100)
        ])
        genreDataView.callback = { genre in
            self.viewModel.selectedGenreResult = genre
            self.loadData()
        }

        headerView.addSubview(gameTitleView)
        NSLayoutConstraint.activate([
            gameTitleView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            gameTitleView.topAnchor.constraint(equalTo: genreDataView.bottomAnchor, constant: 10),
            gameTitleView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            gameTitleView.heightAnchor.constraint(equalToConstant: 30)
        ])

        isGenreViewAdded = true
    }

    private func removeGenreView() {
        genreDataView.removeFromSuperview()
        gameTitleView.removeFromSuperview()
        headerHeightConstraint.constant = 60
        isGenreViewAdded = false
    }

    private func setupSubscriber() {
        viewModel.isEmpty.sink { [weak self] status in
            if status {
                self?.showEmpty()
            }
        }
        .store(in: &cancellables)

        viewModel.isFailed.sink { [weak self] message in
            if !message.isEmpty {
                self?.showFailed(message: message)
            }
        }
        .store(in: &cancellables)

        viewModel.isShowingData.sink { [weak self] status in
            if status {
                self?.showGenreData()
            }
        }
        .store(in: &cancellables)

        viewModel.isShowingFavorite.sink { [weak self] status in
            if status {
                self?.showFavoriteData()
            }
        }
        .store(in: &cancellables)
    }

    private func loadData() {
        view.addSubview(loadingView)

        resetView()
        viewModel.loadAllGames()
    }

    private func loadFavorite() {
        view.addSubview(loadingView)

        removeGenreView()
        resetView()
        viewModel.loadAllFavorites()
    }

    private func resetView() {
        viewModel.dataGame = nil
        viewModel.favoriteGame = nil
        adapter.performUpdates(animated: false)
    }

    private func showEmpty() {
        loadingView.removeFromSuperview()
        showFailed(message: "Data not found")
    }

    private func showGenreData() {
        loadingView.removeFromSuperview()

        if !isGenreViewAdded {
            setupGenreView()
        }

        genreTitleView.changeSelected(viewModel.isFavorited)
        genreDataView.urlAllGames = viewModel.urlAllGames
        genreDataView.build(data: viewModel.dataGenre)
        gameTitleView.setTitle(viewModel.selectedGenreTitle)

        adapter.performUpdates(animated: true)
    }

    private func showFavoriteData() {
        loadingView.removeFromSuperview()

        genreTitleView.changeSelected(viewModel.isFavorited)

        adapter.performUpdates(animated: true)
    }

    private func showFailed(message: String) {
        loadingView.removeFromSuperview()

        let tryAgainAction = UIAlertAction(title: "try_again".localized(), style: .default) { [weak self] _ in
            self?.loadData()
        }
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }

        let alert = UIAlertController(
            title: "info".localized(),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(tryAgainAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func openDetail(_ gameId: Int, _ isFromFavorite: Bool = false) {
        do {
            let viewModel = try ComponentFactory.of(DetailComponent.self).build(())
            viewModel.gameId = gameId
            viewModel.isFromFavorite = isFromFavorite

            let detail = DetailViewController(viewModel: viewModel)
            detail.callback = {
                self.loadFavorite()
            }
            navigationController?.pushViewController(detail, animated: true)
        } catch {
            print("Cleanse Error: \(error)")
        }
    }

    @objc func showSearch(_: UIBarButtonItem) {
        do {
            let search = try ComponentFactory.of(SearchComponent.self).build(())
            search.callback = { gameId in
                self.openDetail(gameId, self.viewModel.isFavorited)
            }
            navigationController?.pushViewController(search, animated: true)
        } catch {
            print("Cleanse Error: \(error)")
        }
    }

    @objc func showProfile(_: UIBarButtonItem) {
        do {
            let profile = try ComponentFactory.of(ProfileComponent.self).build(())
            profile.modalPresentationStyle = .popover
            present(profile, animated: true, completion: nil)
        } catch {
            print("Cleanse Error: \(error)")
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for _: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = []

        if !viewModel.isFavorited, let data = viewModel.dataGame {
            items.append(data)
        }

        if viewModel.isFavorited, let data = viewModel.favoriteGame {
            items.append(data)
        }

        return items
    }

    func listAdapter(_: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is GameSectionModel {
            let gameSection = GameSectionController()
            gameSection.callback = { gameId in
                self.openDetail(gameId)
            }
            return gameSection
        } else if object is FavoriteSectionModel {
            let favoriteSection = FavoriteSectionController()
            favoriteSection.callback = { gameId in
                self.openDetail(gameId, true)
            }
            return favoriteSection
        }

        return ListSectionController()
    }

    func emptyView(for _: ListAdapter) -> UIView? {
        return nil
    }
}
