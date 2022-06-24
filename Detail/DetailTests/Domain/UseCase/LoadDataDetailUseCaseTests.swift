//
//  LoadDataDetailUseCaseTests.swift
//  DetailTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Detail
class LoadDataDetailUseCaseTests: XCTestCase {
    private var networkError: NetworkError?

    func testLoadDataDetailUseCaseSuccess() throws {
        // ARRANGE
        let mapper = GameTransformer()
        let mockResponse: GameModel = mapper.transformResponseToDomain(response: DummyData.dataGameResultResponse)

        let repository = MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>()
        repository.responseValue = mockResponse

        let useCase = LoadDataDetailUseCase<MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
        var response: GameModel?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            networkError = error as? NetworkError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNil(networkError)
        XCTAssertEqual(mockResponse, response)
    }

    func testLoadDataDetailUseCaseFailure() throws {
        // ARRANGE
        let repository = MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>()
        repository.isSuccess = false
        repository.errorValue = NetworkError.invalidResponse

        let useCase = LoadDataDetailUseCase<MockLoadDataDetailRepository<DetailRemoteDataSource, GameTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
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
