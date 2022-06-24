//
//  InsertFavoriteDetailRepositoryTests.swift
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
class InsertFavoriteDetailRepositoryTests: XCTestCase {
    private var databaseError: DatabaseError?

    func testInsertFavoriteDetailRepositorySuccess() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<Bool>()
        locale.responseValue = true

        let mapper = MockFavoriteTransformer()
        mapper.responseEntity = [DummyData.dataFavoriteEntity]

        let repository = InsertFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>, MockFavoriteTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let request = DummyData.dataFavoriteModel
        let resultPublisher = repository.execute(request: request)
        var response: Bool?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(mapper.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(true, response)
    }

    func testInsertFavoriteDetailRepositoryFailureSaving() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<Bool>()
        locale.isSuccess = false
        locale.errorValue = DatabaseError.requestFailed

        let mapper = MockFavoriteTransformer()

        let repository = InsertFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>, MockFavoriteTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let request = DummyData.dataFavoriteModel
        let resultPublisher = repository.execute(request: request)
        do {
            _ = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNotNil(databaseError)
        XCTAssertEqual(DatabaseError.requestFailed, databaseError)
    }

    func testInsertFavoriteDetailRepositoryFailureEmpty() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<Bool>()

        let mapper = MockFavoriteTransformer()

        let repository = InsertFavoriteDetailRepository<MockDetailLocaleDataSource<Bool>, MockFavoriteTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

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
