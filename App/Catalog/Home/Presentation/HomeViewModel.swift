//
//  HomeViewModel.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Foundation

class HomeViewModel {
    private let allGamesImage = [
        "https://media.rawg.io/media/games/b11/b11127b9ee3c3701bd15b9af3286d20e.jpg",
        "https://media.rawg.io/media/games/bc5/bc53067cffecb71129fcb0b4fbf0e922.jpg",
        "https://media.rawg.io/media/games/3e0/3e09bb71ce82dad515df4982a2466e67.jpg",
        "https://media.rawg.io/media/games/290/290068e3847a26968e29a64737f551a6.jpg",
        "https://media.rawg.io/media/games/049/049282a6d9dc2fbf830af7c1bfccd915.jpg"
    ]
    lazy var urlAllGames: String? = allGamesImage.randomElement()

    var selectedGenreResult: GenreModel?
    var selectedGenreTitle: String = "All Games"

    var isEmpty = CurrentValueSubject<Bool, Never>(false)
    var isFailed = CurrentValueSubject<String, Never>("")
    var isShowingData = CurrentValueSubject<Bool, Never>(false)
    var isShowingFavorite = CurrentValueSubject<Bool, Never>(false)

    var dataGenre: [GenreModel] = []
    var dataGame: GameSectionModel?
    var isFavorited: Bool = false
    var favoriteGame: FavoriteSectionModel?

    private var cancellables: Set<AnyCancellable> = []

    private let gamesUseCase: Provider<GamesUseCase>
    private let favoriteUseCase: Provider<FavoriteUseCase>

    init(
        gamesUseCase: Provider<GamesUseCase>,
        favoriteUseCase: Provider<FavoriteUseCase>
    ) {
        self.gamesUseCase = gamesUseCase
        self.favoriteUseCase = favoriteUseCase
    }

    func loadAllGames() {
        isFavorited = false

        var data: [String: Any?] = [:]
        if let genre = selectedGenreResult {
            data["genres"] = genre.id

            selectedGenreTitle = genre.name ?? ""
        } else {
            selectedGenreTitle = "All Games"
        }

        dataGame = nil

        let withGenre = selectedGenreResult == nil
        gamesUseCase.get().loadAllGames(param: data, withGenres: withGenre)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error): self?.isFailed.send(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] response in
                let listGame = GameSectionModel(list: response.1)
                if listGame.list.isEmpty {
                    self?.isEmpty.send(true)
                } else {
                    if !response.0.isEmpty {
                        self?.dataGenre = response.0
                    }

                    self?.dataGame = listGame
                    self?.isShowingData.send(true)
                }
            }
            .store(in: &cancellables)
    }

    func loadAllFavorites() {
        isFavorited = true

        favoriteUseCase.get().getAllFavorite()
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                self?.favoriteGame = FavoriteSectionModel(list: response)
                self?.isShowingFavorite.send(true)
            }
            .store(in: &cancellables)
    }
}
