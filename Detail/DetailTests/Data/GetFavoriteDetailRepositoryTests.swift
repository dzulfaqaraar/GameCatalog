//
//  GetFavoriteDetailRepositoryTests.swift
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
class GetFavoriteDetailRepositoryTests: XCTestCase {
    private var databaseError: DatabaseError?

    private func transformEntityToDomain(entity: FavoriteEntity) -> FavoriteModel {
        FavoriteModel(
            id: entity.id,
            image: entity.image,
            name: entity.name,
            released: entity.released,
            rating: entity.rating,
            date: entity.date
        )
    }

    func testGetFavoriteDetailRepositorySuccess() throws {
        // ARRANGE
        let mockEntity = DummyData.dataFavoriteEntity

        let locale = MockDetailLocaleDataSource<FavoriteEntity>()
        locale.responseValue = mockEntity

        let mapper = MockFavoriteTransformer()
        mapper.responseDomain = [
            transformEntityToDomain(entity: mockEntity)
        ]

        let repository = GetFavoriteDetailRepository<MockDetailLocaleDataSource<FavoriteEntity>, MockFavoriteTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        var response: [FavoriteModel]?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(mapper.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(1, response?.count)
        XCTAssertEqual(mockEntity.id, response?[0].id)
        XCTAssertEqual(mockEntity.name, response?[0].name)
        XCTAssertEqual(mockEntity.image, response?[0].image)
        XCTAssertEqual(mockEntity.released, response?[0].released)
        XCTAssertEqual(mockEntity.rating, response?[0].rating)
        XCTAssertEqual(mockEntity.date, response?[0].date)
    }

    func testGetFavoriteDetailRepositoryFailure() throws {
        // ARRANGE
        let locale = MockDetailLocaleDataSource<FavoriteEntity>()
        locale.isSuccess = false
        locale.errorValue = DatabaseError.requestFailed

        let mapper = MockFavoriteTransformer()

        let repository = GetFavoriteDetailRepository<MockDetailLocaleDataSource<FavoriteEntity>, MockFavoriteTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

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
}
