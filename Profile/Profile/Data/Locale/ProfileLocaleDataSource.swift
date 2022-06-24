//
//  ProfileLocaleDataSource.swift
//  Profile
//
//  Created by Dzulfaqar on 18/06/22.
//

import Combine
import Common
import Core
import UIKit

public struct ProfileLocaleDataSource: LocaleDataSource {
    public typealias Request = Int
    public typealias Response = ProfileEntity

    public init() {}

    private func imageToData(_ title: String) -> Data? {
        guard let img = UIImage(named: title, in: profileBundle, with: nil) else { return nil }
        return img.jpegData(compressionQuality: 1)
    }

    private func addDefaultProfile() {
        let profile = ProfileMemory.sharedInstance
        profile.stateFirst = true
        profile.image = imageToData("me")
        profile.name = "Dzulfaqar"
        profile.website = "www.dzulfaqar.com"
    }

    public func list(request _: Int?) -> AnyPublisher<[ProfileEntity], Error> {
        fatalError()
    }

    public func get(id _: Int?) -> AnyPublisher<ProfileEntity, Error> {
        return Future<ProfileEntity, Error> { completion in
            let profile = ProfileMemory.sharedInstance
            if !profile.stateFirst {
                self.addDefaultProfile()
            }

            profile.synchronize()

            let result = ProfileEntity(image: profile.image, name: profile.name, website: profile.website)
            completion(.success(result))
        }.eraseToAnyPublisher()
    }

    public func add(data _: [ProfileEntity]) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    public func update(data: ProfileEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            let profile = ProfileMemory.sharedInstance
            profile.image = data.image
            profile.name = data.name
            profile.website = data.website

            completion(.success(true))
        }.eraseToAnyPublisher()
    }

    public func delete(id _: Int) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
}
