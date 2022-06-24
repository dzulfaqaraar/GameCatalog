//
//  ProfileViewController.swift
//  Catalog
//
//  Created by Dzulfaqar on 06/06/22.
//

import UIKit

public class ProfileViewController: UIViewController {
    public typealias GetType = GetProfileUseCase<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>
    public typealias UpdateType = UpdateProfileUseCase<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>

    private var viewModel: ProfileViewModel<GetType, UpdateType>

    public init(viewModel: ProfileViewModel<GetType, UpdateType>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var profileDataVC: ProfileDataViewController = {
        let viewController = ProfileDataViewController(viewModel: viewModel)
        self.add(asChildViewController: viewController)

        viewController.dismissCallback = {
            self.dismiss(animated: true, completion: nil)
        }
        viewController.editCallback = {
            self.updateView(true)
        }

        return viewController
    }()

    private lazy var profileEditVC: ProfileEditViewController = {
        let viewController = ProfileEditViewController(viewModel: viewModel)
        self.add(asChildViewController: viewController)

        viewController.dismissCallback = {
            self.dismiss(animated: true, completion: nil)
        }
        viewController.saveCallback = {
            self.updateView(false)
        }

        return viewController
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        updateView(false)
    }

    private func updateView(_ isEditingState: Bool) {
        if isEditingState {
            remove(asChildViewController: profileDataVC)
            add(asChildViewController: profileEditVC)
        } else {
            remove(asChildViewController: profileEditVC)
            add(asChildViewController: profileDataVC)

            profileDataVC.loadProfile()
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        guard let childView = viewController.view else { return }

        view.addSubview(childView)

        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
