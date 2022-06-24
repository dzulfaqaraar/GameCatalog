//
//  ProfileModule.swift
//  Profile
//
//  Created by Dzulfaqar on 19/06/22.
//

import Cleanse
import Core
import Foundation

struct ProfileLocaleDataSourceModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(ProfileLocaleDataSource.self)
            .sharedInScope()
            .to(factory: ProfileLocaleDataSource.init)
    }
}

struct ProfileMapperModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.bind(ProfileTransformer.self)
            .sharedInScope()
            .to(factory: ProfileTransformer.init)
    }
}

struct ProfileRepositoryModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: ProfileLocaleDataSourceModule.self)
        binder.include(module: ProfileMapperModule.self)

        binder.bind(GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>.self)
            .sharedInScope()
            .to(factory: GetProfileRepository.init)

        binder.bind(UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>.self)
            .sharedInScope()
            .to(factory: UpdateProfileRepository.init)
    }
}

struct ProfileUseCaseModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: ProfileRepositoryModule.self)

        binder.bind(GetProfileUseCase<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>.self)
            .sharedInScope()
            .to(factory: GetProfileUseCase.init)
        binder.bind(Interactor<Int, ProfileModel, GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)

        binder.bind(UpdateProfileUseCase<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>.self)
            .sharedInScope()
            .to(factory: UpdateProfileUseCase.init)
        binder.bind(Interactor<ProfileModel, Bool, UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>.self)
            .sharedInScope()
            .to(factory: Interactor.init)
    }
}

public struct ProfileModule: Module {
    typealias GetType = GetProfileUseCase<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>
    typealias UpdateType = UpdateProfileUseCase<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>

    public static func configure(binder: Binder<Singleton>) {
        binder.include(module: ProfileUseCaseModule.self)

        binder.bind(ProfileViewModel<GetType, UpdateType>.self)
            .sharedInScope()
            .to(factory: ProfileViewModel.init)
    }
}
