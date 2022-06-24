//
//  GetProfileUseCase.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class GetProfileUseCase<R: Repository>: UseCase
    where R.Request == Int,
    R.Response == ProfileModel {
    public typealias Request = Int
    public typealias Response = ProfileModel

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: Int?) -> AnyPublisher<ProfileModel, Error> {
        repository.get().execute(request: request)
    }
}
