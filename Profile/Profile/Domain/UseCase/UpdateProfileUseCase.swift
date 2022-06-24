//
//  UpdateProfileUseCase.swift
//  Profile
//
//  Created by Dzulfaqar on 20/06/22.
//

import Cleanse
import Combine
import Common
import Core
import Foundation

public class UpdateProfileUseCase<R: Repository>: UseCase
    where R.Request == ProfileModel,
    R.Response == Bool {
    public typealias Request = ProfileModel
    public typealias Response = Bool

    private let repository: Provider<R>

    public init(repository: Provider<R>) {
        self.repository = repository
    }

    public func execute(request: ProfileModel?) -> AnyPublisher<Bool, Error> {
        repository.get().execute(request: request)
    }
}
