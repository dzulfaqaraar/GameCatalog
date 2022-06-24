//
//  DeleteFavoriteDetailRepositoryTests.swift
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
class DeleteFavoriteDetailRepositoryTests: XCTestCase {
    private var databaseError: DatabaseError?

    func testDeleteFavoriteDetailRepositorySuccess() throws {
        // ARRANGE
        let mockResponse = true

        let locale = MockDetailLocaleDataSource<Bool>()
        locale.responseValue = mockResponse

        let repository = DeleteFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>>(locale: Provider(value: locale))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        var response: Bool?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNil(databaseError)
        XCTAssertEqual(mockResponse, response)
    }

    func testDeleteFavoriteDetailRepositoryFailureDeleting() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<Bool>()
        locale.isSuccess = false
        locale.errorValue = DatabaseError.requestFailed

        let repository = DeleteFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>>(locale: Provider(value: locale))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        do {
            _ = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNotNil(databaseError)
        XCTAssertEqual(DatabaseError.requestFailed, databaseError)
    }

    func testDeleteFavoriteDetailRepositoryFailureEmpty() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<Bool>()

        let repository = DeleteFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>>(locale: Provider(value: locale))

        // ACT
        let resultPublisher = repository.execute(request: nil)
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
