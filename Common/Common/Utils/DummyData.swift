//
//  DummyData.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public enum DummyData {
    // MARK: - Data Remote

    public static let listGenreResultResponse: [GenreResultResponse] = [
        GenreResultResponse(id: 1, name: "Action", imageBackground: "https://media.rawg.io/media/games/d58/d588947d4286e7b5e0e12e1bea7d9844.jpg"),
        GenreResultResponse(id: 2, name: "Adventure", imageBackground: "https://media.rawg.io/media/games/562/562553814dd54e001a541e4ee83a591c.jpg"),
        GenreResultResponse(id: nil, name: "Arcade", imageBackground: "https://media.rawg.io/media/games/23d/23d78acedbb5f40c9fb64e73af5af65d.jpg")
    ]

    public static let dataGenreResultResponse: GenreResultResponse = listGenreResultResponse.first!

    public static let listGameResultResponse: [GameResultResponse] = [
        GameResultResponse(
            id: 1,
            slug: "grand-theft-auto-v",
            name: "Grand Theft Auto V",
            released: "2013-09-17",
            descriptionRaw: "Grand Theft Auto V",
            backgroundImage: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
            rating: 4.48,
            developers: [
                DeveloperResponse(name: "Rockstar North"),
                DeveloperResponse(name: "Rockstar Games")
            ],
            genres: [
                GenreResultResponse(id: 1, name: "Action", imageBackground: nil),
                GenreResultResponse(id: 2, name: "Adventure", imageBackground: nil)
            ],
            publishers: [
                PublisherResponse(name: "Rockstar Games")
            ]
        ),
        GameResultResponse(
            id: 2,
            slug: "the-witcher-3-wild-hunt",
            name: "The Witcher 3: Wild Hunt",
            released: "2015-05-18",
            descriptionRaw: "The Witcher 3: Wild Hunt",
            backgroundImage: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
            rating: 4.67,
            developers: [
                DeveloperResponse(name: "CD PROJEKT RED"),
                DeveloperResponse(name: nil)
            ],
            genres: [
                GenreResultResponse(id: 1, name: "Action", imageBackground: nil),
                GenreResultResponse(id: 2, name: "Adventure", imageBackground: nil),
                GenreResultResponse(id: 3, name: nil, imageBackground: nil),
                GenreResultResponse(id: 4, name: "RPG", imageBackground: nil)
            ],
            publishers: [
                PublisherResponse(name: "CD PROJEKT RED"),
                PublisherResponse(name: nil)
            ]
        )
    ]

    public static let dataGameResultResponse: GameResultResponse = listGameResultResponse.first!
    public static let dataGameResponse: GameResponse = .init(results: [dataGameResultResponse])

    // MARK: - Data Locale

    public static let listGenreEntity: [GenreEntity] = [
        GenreEntity(id: 1, name: "Action", image: "https://media.rawg.io/media/games/d58/d588947d4286e7b5e0e12e1bea7d9844.jpg"),
        GenreEntity(id: 2, name: "Adventure", image: "https://media.rawg.io/media/games/562/562553814dd54e001a541e4ee83a591c.jpg"),
        GenreEntity(id: nil, name: "Arcade", image: "https://media.rawg.io/media/games/23d/23d78acedbb5f40c9fb64e73af5af65d.jpg")
    ]

    public static let dataGenreEntity: GenreEntity = listGenreEntity.first!

    public static let listFavoriteEntity: [FavoriteEntity] = [
        FavoriteEntity(id: 1, image: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", name: "Grand Theft Auto V", released: "2013-09-17", rating: 4.48, date: Date()),
        FavoriteEntity(id: 2, image: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg", name: "The Witcher 3: Wild Hunt", released: "2015-05-18", rating: 4.67, date: Date())
    ]

    public static let dataFavoriteEntity: FavoriteEntity = listFavoriteEntity.first!

    // MARK: - Domain Model

    public static let listFavoriteModel: [FavoriteModel] = [
        FavoriteModel(id: 1, image: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", name: "Grand Theft Auto V", released: "2013-09-17", rating: 4.48, date: Date())
    ]

    public static let dataFavoriteModel = listFavoriteModel.first!

    public static let listGameModel: [GameModel] = [
        GameModel(id: 1, rating: 4.48, name: "Grand Theft Auto V", image: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", released: "2013-09-17", descriptionRaw: "", developersName: "Developer", publishersName: "Publisher", genres: "Action")
    ]

    public static let dataGameModel = listGameModel.first!
}
