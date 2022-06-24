//
//  GamesUseCaseTests.swift
//  CatalogTests
//
//  Created by Dzulfaqar on 14/06/22.
//

import Combine
import Common
import XCTest

@testable import Catalog
class GamesUseCaseTests: XCTestCase {
    private var networkError: NetworkError?

    func testLoadAllGamesSuccess() throws {
        // ARRANGE
        let repository = MockHomeRepository<([GenreModel], [GameModel])>()

        let genreMapper = GenreTransformer()
        let gameMapper = GameTransformer()

        let mockResponse: ([GenreModel], [GameModel]) = (
            genreMapper.transformEntityToDomain(entity: DummyData.listGenreEntity),
            gameMapper.transformResponseToDomain(response: DummyData.listGameResultResponse)
        )
        repository.responseValue = mockResponse

        let useCase = GamesInteractorMock(repository: repository)

        // ACT
        let resultPublisher = useCase.loadAllGames(param: [:], withGenres: true)

        // ASSERT
        XCTAssert(useCase.verify())

        // ACT
        var response: ([GenreModel], [GameModel])?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNil(networkError)
        XCTAssertEqual(mockResponse.0.count, response?.0.count)
        XCTAssertEqual(mockResponse.1.count, response?.1.count)
        XCTAssertEqual(mockResponse.0, response?.0)
        XCTAssertEqual(mockResponse.1, response?.1)
    }

    func testLoadAllGamesFailure() throws {
        // ARRANGE
        let repository = MockHomeRepository<([GenreModel], [GameModel])>()
        repository.isSuccess = false
        repository.errorValue = NetworkError.invalidResponse

        let useCase = GamesInteractorMock(repository: repository)

        // ACT
        let resultPublisher = useCase.loadAllGames(param: [:], withGenres: true)
        do {
            _ = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNotNil(networkError)
        XCTAssertEqual(NetworkError.invalidResponse, networkError)
    }
}

extension GamesUseCaseTests {
    class GamesInteractorMock: GamesUseCase {
        var functionWasCalled = false

        var repository: HomeRepositoryProtocol

        init(repository: HomeRepositoryProtocol) {
            self.repository = repository
        }

        func verify() -> Bool {
            return functionWasCalled
        }

        func loadAllGames(param: [String: Any?], withGenres: Bool) -> AnyPublisher<([GenreModel], [GameModel]), Error> {
            functionWasCalled = true
            return repository.loadAllGames(param: param, withGenres: withGenres)
        }
    }
}
