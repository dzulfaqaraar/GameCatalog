//
//  UpdateProfileUseCaseTests.swift
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
class UpdateProfileUseCaseTests: XCTestCase {
    private var databaseError: DatabaseError?

    private func mockProfileModel() -> ProfileModel {
        let image = UIImage(named: "me", in: profileBundle, with: nil)!
        let imageData = image.jpegData(compressionQuality: 1)
        return ProfileModel(image: imageData!, name: "Dzulfaqar", website: "www.dzulfaqar.com")
    }

    func testUpdateProfileSuccess() throws {
        // ARRANGE
        let repository = MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
        repository.responseValue = true

        let useCase = UpdateProfileUseCase<MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: mockProfileModel())
        var response: Bool?
        do {
            response = try awaitPublisher(resultPublisher).get()
        } catch {
            databaseError = error as? DatabaseError
        }

        // ASSERT
        XCTAssertNil(databaseError)
        XCTAssertEqual(true, response)
    }

    func testUpdateProfileFailure() throws {
        // ARRANGE
        let repository = MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>()
        repository.isSuccess = false
        repository.errorValue = DatabaseError.requestFailed

        let useCase = UpdateProfileUseCase<MockUpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>(repository: Provider(value: repository))

        // ACT
        let resultPublisher = useCase.execute(request: mockProfileModel())
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
