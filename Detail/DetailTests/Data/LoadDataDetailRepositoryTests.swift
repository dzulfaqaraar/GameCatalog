//
//  LoadDataDetailRepositoryTests.swift
//  DetailTests
//
//  Created by Dzulfaqar on 22/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Detail
class LoadDataDetailRepositoryTests: XCTestCase {
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

    func testLoadDataDetailRepositorySuccess() throws {
        // ARRANGE
        let mockResponse = DummyData.dataGameResultResponse

        let remote = MockDetailRemoteDataSource()
        remote.responseValue = mockResponse

        let mapper = MockGameTransformer()
        mapper.responseDomain = [
            transformResponseToDomain(response: mockResponse)
        ]

        let repository = LoadDataDetailRepository<MockDetailRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        var response: GameModel?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNil(networkError)
        XCTAssertEqual(mockResponse.id, response?.id)
        XCTAssertEqual(mockResponse.rating, response?.rating)
        XCTAssertEqual(mockResponse.name, response?.name)
        XCTAssertEqual(mockResponse.backgroundImage, response?.image)
        XCTAssertEqual(mockResponse.released, response?.released)
        XCTAssertEqual(mockResponse.descriptionRaw, response?.descriptionRaw)

        let mockDevelopers = mockResponse.developers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockDevelopers, response?.developersName)

        let mockPublishers = mockResponse.publishers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockPublishers, response?.publishersName)

        let mockGenres = mockResponse.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(mockGenres, response?.genres)
    }

    func testLoadDataDetailRepositoryEmpty() throws {
        // ARRANGE
        let remote = MockDetailRemoteDataSource()
        remote.responseValue = nil

        let mapper = MockGameTransformer()

        let repository = LoadDataDetailRepository<MockDetailRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        var response: GameModel?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssertNil(networkError)
        XCTAssertNil(response)
    }

    func testLoadDataDetailRepositoryFailure() throws {
        // ARRANGE
        let remote = MockDetailRemoteDataSource()
        remote.isSuccess = false
        remote.errorValue = NetworkError.invalidResponse

        let mapper = MockGameTransformer()

        let repository = LoadDataDetailRepository<MockDetailRemoteDataSource, MockGameTransformer>(remote: Provider(value: remote), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: 1)
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
