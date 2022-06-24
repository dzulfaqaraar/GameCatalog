//
//  GetProfileRepositoryTests.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 23/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Profile
class GetProfileRepositoryTests: XCTestCase {
    private var databaseError: DatabaseError?

    private func mockProfileEntity() -> ProfileEntity {
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        return ProfileEntity(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")
    }

    private func transformEntityToDomain(entity: ProfileEntity) -> ProfileModel {
        ProfileModel(image: entity.image, name: entity.name, website: entity.website)
    }

    func testGetProfileRepositorySuccess() throws {
        // ARRANGE
        let mockEntity = mockProfileEntity()

        let locale = MockProfileLocaleDataSource<ProfileEntity>()
        locale.responseValue = mockEntity

        let mapper = MockProfileTransformer()
        mapper.responseDomain = transformEntityToDomain(entity: mockEntity)

        let repository = GetProfileRepository<MockProfileLocaleDataSource<ProfileEntity>, MockProfileTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: 1)
        var response: ProfileModel?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(mapper.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(mockEntity.image, response?.image)
        XCTAssertEqual(mockEntity.name, response?.name)
        XCTAssertEqual(mockEntity.website, response?.website)
    }

    func testGetProfileRepositoryFailure() throws {
        // ARRANGE
        let locale = MockProfileLocaleDataSource<ProfileEntity>()
        locale.isSuccess = false
        locale.errorValue = DatabaseError.requestFailed

        let mapper = MockProfileTransformer()

        let repository = GetProfileRepository<MockProfileLocaleDataSource<ProfileEntity>, MockProfileTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

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
