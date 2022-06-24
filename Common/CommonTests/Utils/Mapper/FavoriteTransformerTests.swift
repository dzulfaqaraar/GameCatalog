//
//  FavoriteTransformerTests.swift
//  CommonTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import XCTest

@testable import Common
class FavoriteTransformerTests: XCTestCase {
    func testTransformEntityToDomain() {
        // ARRANGE
        let list: [FavoriteEntity] = DummyData.listFavoriteEntity
        let data: FavoriteEntity = DummyData.dataFavoriteEntity

        // ACT
        let mapper = FavoriteTransformer()
        let listMapped = mapper.transformEntityToDomain(entity: list)
        let dataMapped = mapper.transformEntityToDomain(entity: data)

        // ASSERT
        XCTAssertEqual(2, listMapped.count)

        XCTAssertEqual(data.id, dataMapped.id)
        XCTAssertEqual(data.image, dataMapped.image)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.released, dataMapped.released)
        XCTAssertEqual(data.rating, dataMapped.rating)
        XCTAssertEqual(data.date, dataMapped.date)
    }

    func testTransformDomainToEntity() {
        // ARRANGE
        let list: [FavoriteModel] = DummyData.listFavoriteModel
        let data: FavoriteModel = DummyData.dataFavoriteModel

        // ACT
        let mapper = FavoriteTransformer()
        let listMapped = mapper.transformDomainToEntity(domain: list)
        let dataMapped = mapper.transformDomainToEntity(domain: data)

        // ASSERT
        XCTAssertEqual(1, listMapped.count)

        XCTAssertEqual(data.id, dataMapped.id)
        XCTAssertEqual(data.image, dataMapped.image)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.released, dataMapped.released)
        XCTAssertEqual(data.rating, dataMapped.rating)
        XCTAssertEqual(data.date, dataMapped.date)
    }
}
