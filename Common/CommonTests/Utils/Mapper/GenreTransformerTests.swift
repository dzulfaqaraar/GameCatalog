//
//  GenreTransformerTests.swift
//  CommonTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import XCTest

@testable import Common
class GenreTransformerTests: XCTestCase {
    func testTransformResponseToEntity() {
        // ARRANGE
        let list: [GenreResultResponse] = DummyData.listGenreResultResponse
        let data: GenreResultResponse = DummyData.dataGenreResultResponse

        // ACT
        let mapper = GenreTransformer()
        let listMapped = mapper.transformResponseToEntity(response: list)
        let dataMapped = mapper.transformResponseToEntity(response: data)

        // ASSERT
        XCTAssertEqual(3, listMapped.count)

        XCTAssertEqual(Int32(data.id ?? -1), dataMapped.id)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.imageBackground, dataMapped.image)
    }

    func testTransformEntityToDomain() {
        // ARRANGE
        let list: [GenreEntity] = DummyData.listGenreEntity
        let data: GenreEntity = DummyData.dataGenreEntity

        // ACT
        let mapper = GenreTransformer()
        let listMapped = mapper.transformEntityToDomain(entity: list)
        let dataMapped = mapper.transformEntityToDomain(entity: data)

        // ASSERT
        XCTAssertEqual(3, listMapped.count)

        XCTAssertEqual(Int(data.id ?? -1), dataMapped.id)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.image, dataMapped.image)
    }
}
