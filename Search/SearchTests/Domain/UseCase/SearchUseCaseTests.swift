//
//  SearchUseCaseTests.swift
//  SearchTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Search
class SearchUseCaseTests: XCTestCase {
    private var networkError: NetworkError?

    func testLoadAllGamesSuccess() throws {
        // ARRANGE
        let repository = MockSearchRepository<SearchRemoteDataSource, GameTransformer>()

        let gameMapper = GameTransformer()
        let mockResponse: [GameModel] = gameMapper.transformResponseToDomain(response: DummyData.listGameResultResponse)
        repository.responseValue = mockResponse

        let useCase = SearchUseCase<MockSearchRepository<SearchRemoteDataSource, GameTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: [:])
        var response: [GameModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNil(networkError)
        XCTAssertEqual(mockResponse.count, response?.count)
        XCTAssertEqual(mockResponse, response)
    }

    func testLoadAllGamesFailure() throws {
        // ARRANGE
        let repository = MockSearchRepository<SearchRemoteDataSource, GameTransformer>()
        repository.isSuccess = false
        repository.errorValue = NetworkError.invalidResponse

        let useCase = SearchUseCase<MockSearchRepository<SearchRemoteDataSource, GameTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: [:])
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
