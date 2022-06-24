//
//  FavoriteUseCaseTests.swift
//  CatalogTests
//
//  Created by Dzulfaqar on 15/06/22.
//

import Combine
import Common
import XCTest

@testable import Catalog
class FavoriteUseCaseTests: XCTestCase {
    private var databaseError: DatabaseError?

    func testGetAllFavoriteSuccess() throws {
        // ARRANGE
        let repository = MockHomeRepository<[FavoriteModel]>()

        let mapper = FavoriteTransformer()
        let mockResponse: [FavoriteModel] = mapper.transformEntityToDomain(entity: DummyData.listFavoriteEntity)
        repository.responseValue = mockResponse

        let useCase = FavoriteInteractorMock(repository: repository)

        // ACT
        let resultPublisher = useCase.getAllFavorite()

        // ASSERT
        XCTAssert(useCase.verify())

        // ACT
        var response: [FavoriteModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNil(databaseError)
        XCTAssertEqual(mockResponse.count, response?.count)
        XCTAssertEqual(mockResponse, response)
    }

    func testGetAllFavoriteFailure() throws {
        // ARRANGE
        let repository = MockHomeRepository<[FavoriteModel]>()
        repository.isSuccess = false
        repository.errorValue = DatabaseError.requestFailed

        let useCase = FavoriteInteractorMock(repository: repository)

        // ACT
        let resultPublisher = useCase.getAllFavorite()
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

extension FavoriteUseCaseTests {
    class FavoriteInteractorMock: FavoriteUseCase {
        var functionWasCalled = false

        var repository: HomeRepositoryProtocol

        init(repository: HomeRepositoryProtocol) {
            self.repository = repository
        }

        func verify() -> Bool {
            return functionWasCalled
        }

        func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error> {
            functionWasCalled = true
            return repository.getAllFavorite()
        }
    }
}
