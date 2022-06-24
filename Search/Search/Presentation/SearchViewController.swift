//
//  SearchViewController.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import UIKit

public class SearchViewController: UIViewController {
    private var viewModel: SearchViewModel

    public var callback: ((_ gameId: Int) -> Void)?

    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: SearchViewController.self),
            bundle: searchBundle
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!

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

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)

        let space: CGFloat = flowLayout.minimumInteritemSpacing +
            flowLayout.sectionInset.left +
            flowLayout.sectionInset.right
        let width = (view.bounds.width - space - 80) / 2.0
        flowLayout.itemSize = CGSize(width: width, height: 300)

        return flowLayout
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubscriber()
    }

    private func setupView() {
        navigationItem.title = "search_title".localized()

        searchBar.delegate = self

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(
                nibName: String(describing: SearchCollectionViewCell.self),
                bundle: searchBundle
            ),
            forCellWithReuseIdentifier: SearchCollectionViewCell.description()
        )
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    private func setupSubscriber() {
        viewModel.isShowingData.sink { [weak self] status in
            if status {
                self?.showData()
            }
        }
        .store(in: &cancellables)

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

        viewModel.isSearching
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map { !$0.isEmpty }
            .sink { [weak self] status in
                if status {
                    self?.loadData()
                }
            }
            .store(in: &cancellables)
    }

    private func loadData() {
        view.addSubview(loadingView)

        resetData()
        viewModel.searchGames()
    }

    private func resetData() {
        viewModel.dataGame = []
        collectionView.reloadData()
    }

    private func showEmpty() {
        loadingView.removeFromSuperview()
        showFailed(message: "Data not found")
    }

    private func showData() {
        loadingView.removeFromSuperview()

        view.addSubview(collectionView)

        collectionView.reloadData()
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
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(by: searchBar.text ?? "")
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        viewModel.search(by: searchBar.text ?? "")
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.dataGame.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.description(), for: indexPath
        ) as? SearchCollectionViewCell {
            let data = viewModel.dataGame[indexPath.row]
            cell.callback = { gameId in
                self.callback?(gameId)
            }
            cell.setup(with: data)
            return cell
        }

        return UICollectionViewCell()
    }
}
