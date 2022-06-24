//
//  ProfileViewModel.swift
//  Catalog
//
//  Created by Dzulfaqar on 07/06/22.
//

import Cleanse
import Combine
import Core
import Foundation

public class ProfileViewModel<GetUseCase: UseCase, UpdateUseCase: UseCase>
    where GetUseCase.Request == Int,
    GetUseCase.Response == ProfileModel,
    UpdateUseCase.Request == ProfileModel,
    UpdateUseCase.Response == Bool {
    private var cancellables: Set<AnyCancellable> = []

    var profileData: ProfileModel?
    var isShowingData = CurrentValueSubject<Bool, Never>(false)
    var profileUpdated = CurrentValueSubject<Bool, Never>(false)

    private let getUseCase: Provider<GetUseCase>
    private let updateUseCase: Provider<UpdateUseCase>

    public init(
        getUseCase: Provider<GetUseCase>,
        updateUseCase: Provider<UpdateUseCase>
    ) {
        self.getUseCase = getUseCase
        self.updateUseCase = updateUseCase
    }

    func loadProfile() {
        getUseCase.get().execute(request: nil)
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                self?.profileData = response
                self?.isShowingData.send(true)
            }
            .store(in: &cancellables)
    }

    func saveProfile(
        _ image: Data,
        _ name: String,
        _ website: String
    ) {
        let request = ProfileModel(image: image, name: name, website: website)
        updateUseCase.get().execute(request: request)
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.profileUpdated.send(true)
            }
            .store(in: &cancellables)
    }
}
