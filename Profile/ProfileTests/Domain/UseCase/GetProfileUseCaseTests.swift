//
//  GetProfileUseCaseTests.swift
//  ProfileTests
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import XCTest

@testable import Profile
class GetProfileUseCaseTests: XCTestCase {
    private var databaseError: DatabaseError?

    private func mockProfileModel() -> ProfileModel {
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        return ProfileModel(image: imageData, name: "Dzulfaqar", website: "www.dzulfaqar.com")
    }

    func testLoadProfileSuccess() throws {
        // ARRANGE
        let mockResponse = mockProfileModel()

        let repository = MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
        repository.responseValue = mockResponse

        let useCase = GetProfileUseCase<MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: 1)
        var response: ProfileModel?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNil(databaseError)
        XCTAssertEqual(mockResponse.image, response?.image)
        XCTAssertEqual(mockResponse.name, response?.name)
        XCTAssertEqual(mockResponse.website, response?.website)
    }

    func testLoadProfileFailure() throws {
        // ARRANGE
        let repository = MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
        repository.isSuccess = false
        repository.errorValue = DatabaseError.requestFailed

        let useCase = GetProfileUseCase<MockGetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: nil)
        do {
            _ = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssert(repository.verify())
        XCTAssertNotNil(databaseError)
        XCTAssertEqual(DatabaseError.requestFailed, databaseError)
    }
}
