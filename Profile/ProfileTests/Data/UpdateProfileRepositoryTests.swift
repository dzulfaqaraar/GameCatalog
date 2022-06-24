//
//  UpdateProfileRepositoryTests.swift
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
class UpdateProfileRepositoryTests: XCTestCase {
    private var databaseError: DatabaseError?

    private func mockProfileModel() -> ProfileModel {
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        return ProfileModel(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")
    }

    private func transformDomainToEntity(domain: ProfileModel) -> ProfileEntity {
        ProfileEntity(image: domain.image, name: domain.name, website: domain.website)
    }

    func testUpdateProfileRepositorySuccess() throws {
        // ARRANGE
        let mockDomain = mockProfileModel()

        let locale = MockProfileLocaleDataSource<Bool>()
        locale.responseValue = true

        let mapper = MockProfileTransformer()
        mapper.responseEntity = transformDomainToEntity(domain: mockDomain)

        let repository = UpdateProfileRepository<MockProfileLocaleDataSource<Bool>, MockProfileTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: mockDomain)
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

    func testUpdateProfileRepositoryFailure() throws {
        // ARRANGE
        let mockDomain = mockProfileModel()

        let locale = MockProfileLocaleDataSource<Bool>()
        locale.isSuccess = false
        locale.errorValue = DatabaseError.requestFailed

        let mapper = MockProfileTransformer()
        mapper.responseEntity = transformDomainToEntity(domain: mockDomain)

        let repository = UpdateProfileRepository<MockProfileLocaleDataSource<Bool>, MockProfileTransformer>(locale: Provider(value: locale), mapper: Provider(value: mapper))

        // ACT
        let resultPublisher = repository.execute(request: mockDomain)
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
