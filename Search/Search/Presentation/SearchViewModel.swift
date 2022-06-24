//
//  SearchViewModel.swift
//  Search
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class SearchViewModel {
    var isEmpty = CurrentValueSubject<Bool, Never>(false)
    var isFailed = CurrentValueSubject<String, Never>("")
    var isShowingData = CurrentValueSubject<Bool, Never>(false)
    var isSearching = CurrentValueSubject<String, Never>("")

    private var keyword: String = ""

    private var cancellables: Set<AnyCancellable> = []

    private let gamesUseCase: Provider<Interactor<[String: Any?], [GameModel], SearchRepository<SearchRemoteDataSource, GameTransformer>>>

    public init(gamesUseCase: Provider<Interactor<[String: Any?], [GameModel], SearchRepository<SearchRemoteDataSource, GameTransformer>>>) {
        self.gamesUseCase = gamesUseCase
    }

    var dataGame: [GameModel] = []

    func search(by keyword: String) {
        self.keyword = keyword
        isSearching.send(keyword)
    }

    func searchGames() {
        let data = ["search": keyword]

        gamesUseCase.get().execute(request: data)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error): self?.isFailed.send(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] response in
                if response.isEmpty {
                    self?.isEmpty.send(true)
                } else {
                    self?.dataGame = response
                    self?.isShowingData.send(true)
                }
            }
            .store(in: &cancellables)
    }
}
