//
//  DeleteFavoriteDetailUseCaseTests.swift
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
class DeleteFavoriteDetailUseCaseTests: XCTestCase {
    private var databaseError: DatabaseError?

    func testDeleteFavoriteDetailUseCaseSuccess() throws {
        // ARRANGE
        let repository = MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>()
        repository.responseValue = true

        let useCase = DeleteFavoriteDetailUseCase<MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
        var response: Bool?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(true, response)
    }

    func testDeleteFavoriteDetailUseCaseFailure() throws {
        // ARRANGE
        let repository = MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>()
        repository.isSuccess = false
        repository.errorValue = DatabaseError.requestFailed

        let useCase = DeleteFavoriteDetailUseCase<MockDeleteFavoriteDetailRepository<DetailLocaleDataSource>>(repository: Provider(value: repository))

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
