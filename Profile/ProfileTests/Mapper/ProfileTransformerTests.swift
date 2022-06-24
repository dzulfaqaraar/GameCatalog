//
//  ProfileTransformerTests.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 21/06/22.
//

import Common
import XCTest

@testable import Profile
class ProfileTransformerTests: XCTestCase {
    func testTransformEntityToDomain() {
        // ARRANGE
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        let data = ProfileEntity(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")

        // ACT
        let mapper = ProfileTransformer()
        let dataMapped = mapper.transformEntityToDomain(entity: data)

        // ASSERT
        XCTAssertEqual(data.image, dataMapped.image)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.website, dataMapped.website)
    }

    func testTransformDomainToEntity() {
        // ARRANGE
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        let data = ProfileModel(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")

        // ACT
        let mapper = ProfileTransformer()
        let dataMapped = mapper.transformDomainToEntity(domain: data)

        // ASSERT
        XCTAssertEqual(data.image, dataMapped.image)
        XCTAssertEqual(data.name, dataMapped.name)
        XCTAssertEqual(data.website, dataMapped.website)
    }
}
