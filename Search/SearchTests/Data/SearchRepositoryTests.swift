//
//  SearchRepositoryTests.swift
//  SearchTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Search
class SearchRepositoryTests: XCTestCase {
    private var networkError: NetworkError?

    private func transformResponseToDomain(response: GameResultResponse) -> GameModel {
        GameModel(
            id: response.id,
            rating: response.rating,
            name: response.name,
            image: response.backgroundImage,
            released: response.released,
            descriptionRaw: response.descriptionRaw,
            developersName: response.developers?.map { $0.name ?? "" }.joined(separator: ", "),
            publishersName: response.publishers?.map { $0.name ?? "" }.joined(separator: ", "),
            genres: response.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        )
    }

    func testSearchRepositorySuccess() throws {
        // ARRANGE
        let mockResponse = DummyData.dataGameResponse

        let remote = MockSearchRemoteDataSource()
        remote.responseValue = mockResponse

        let mapper = MockGameTransformer()
        mapper.responseDomain = mockResponse.results?.map { response in
            transformResponseToDomain(response: response)
        } ?? []

        let repository = SearchRepository<MockSearchRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: [:])
        var response: [GameModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNil(networkError)
        XCTAssertEqual(mockResponse.results?.count, response?.count)
        XCTAssertEqual(mockResponse.results?[0].id, response?[0].id)
        XCTAssertEqual(mockResponse.results?[0].rating, response?[0].rating)
        XCTAssertEqual(mockResponse.results?[0].name, response?[0].name)
        XCTAssertEqual(mockResponse.results?[0].backgroundImage, response?[0].image)
        XCTAssertEqual(mockResponse.results?[0].released, response?[0].released)
        XCTAssertEqual(mockResponse.results?[0].descriptionRaw, response?[0].descriptionRaw)

        let mockDevelopers = mockResponse.results?[0].developers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockDevelopers, response?[0].developersName)

        let mockPublishers = mockResponse.results?[0].publishers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockPublishers, response?[0].publishersName)

        let mockGenres = mockResponse.results?[0].genres?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockGenres, response?[0].genres)
    }

    func testSearchRepositoryEmpty() throws {
        // ARRANGE
        let remote = MockSearchRemoteDataSource()
        remote.responseValue = GameResponse(results: nil)

        let mapper = MockGameTransformer()

        let repository = SearchRepository<MockSearchRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: [:])
        var response: [GameModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNil(networkError)
        XCTAssertEqual(true, response?.isEmpty)
    }

    func testSearchRepositoryFailure() throws {
        // ARRANGE
        let remote = MockSearchRemoteDataSource()
        remote.isSuccess = false
        remote.errorValue = NetworkError.invalidResponse

        let mapper = MockGameTransformer()

        let repository = SearchRepository<MockSearchRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: [:])
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
