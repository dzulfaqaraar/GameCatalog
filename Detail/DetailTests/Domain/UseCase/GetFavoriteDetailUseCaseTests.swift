//
//  GetFavoriteDetailUseCaseTests.swift
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
class GetFavoriteDetailUseCaseTests: XCTestCase {
    private var databaseError: DatabaseError?

    func testGetFavoriteDetailUseCaseSuccess() throws {
        // ARRANGE
        let mapper = FavoriteTransformer()
        let mockResponse: [FavoriteModel] = [mapper.transformEntityToDomain(entity: DummyData.dataFavoriteEntity)]

        let repository = MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()
        repository.responseValue = mockResponse

        let useCase = GetFavoriteDetailUseCase<MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
        var response: [FavoriteModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(mockResponse, response)
    }

    func testGetFavoriteDetailUseCaseFailure() throws {
        // ARRANGE
        let repository = MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>()
        repository.isSuccess = false
        repository.errorValue = DatabaseError.requestFailed

        let useCase = GetFavoriteDetailUseCase<MockGetFavoriteDetailRepository<DetailLocaleDataSource, FavoriteTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
        do {
            _ = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNotNil(databaseError)
        XCTAssertEqual(DatabaseError.requestFailed, databaseError)
    }
}
