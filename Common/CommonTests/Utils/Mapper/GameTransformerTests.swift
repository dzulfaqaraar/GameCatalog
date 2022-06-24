//
//  GameTransformerTests.swift
//  CommonTests
//
//  Created by Dzulfaqar on 19/06/22.
//

import XCTest

@testable import Common
class GameTransformerTests: XCTestCase {
    func testTransformResponseToDomain() {
        // ARRANGE
        let list: [GameResultResponse] = DummyData.listGameResultResponse
        let data: GameResultResponse = DummyData.dataGameResultResponse

        // ACT
        let mapper = GameTransformer()
        let listMapped = mapper.transformResponseToDomain(response: list)
        let dataMapped = mapper.transformResponseToDomain(response: data)

        // ASSERT
        XCTAssertEqual(2, listMapped.count)

        XCTAssertEqual(data.id, dataMapped.id)
        XCTAssertEqual(data.rating, dataMapped.rating)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.backgroundImage, dataMapped.image)
        XCTAssertEqual(data.released, dataMapped.released)
        XCTAssertEqual(data.descriptionRaw, dataMapped.descriptionRaw)

        let developers = data.developers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(developers, dataMapped.developersName)

        let publishers = data.publishers?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(publishers, dataMapped.publishersName)

        let genres = data.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        XCTAssertEqual(genres, dataMapped.genres)
    }
}
