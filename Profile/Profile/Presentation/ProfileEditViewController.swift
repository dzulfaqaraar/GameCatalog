//
//  ProfileEditViewController.swift
//  Catalog
//
//  Created by Dzulfaqar on 06/06/22.
//

import Combine
import Common
import UIKit

class ProfileEditViewController: UIViewController {
    typealias GetType = GetProfileUseCase<GetProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>
    typealias UpdateType = UpdateProfileUseCase<UpdateProfileRepository<ProfileLocaleDataSource, ProfileTransformer>>

    private var viewModel: ProfileViewModel<GetType, UpdateType>

    init(viewModel: ProfileViewModel<GetType, UpdateType>) {
        self.viewModel = viewModel
        super.init(
            nibName: String(describing: ProfileEditViewController.self),
            bundle: profileBundle
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!

    private var cancellables: Set<AnyCancellable> = []

    private let imagePicker = UIImagePickerController()

    var dismissCallback: (() -> Void)?
    var saveCallback: (() -> Void)?

    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "save".localized()
        button.action = #selector(saveButtonPressed)
        return button
    }()

    private lazy var navBar: UINavigationBar = {
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.action = #selector(backButtonPressed)

        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "profile_title".localized())
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = saveButton

        navBar.setItems([navItem], animated: false)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubscriberEvent()

        setupForm(for: nameTextField)
        setupForm(for: websiteTextField)
        setupSubscriberForm()

        viewModel.loadProfile()
    }

    private func setupView() {
        view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44)
        ])

        profileImage.layer.cornerRadius = profileImage.frame.height / 2

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }

    private func setupForm(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.frame = CGRect(
            x: CGFloat(nameTextField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )

        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        button.configuration = configuration

        switch textField {
        case nameTextField:
            button.addTarget(self, action: #selector(showNameAlert(_:)), for: .touchUpInside)
        case websiteTextField:
            button.addTarget(self, action: #selector(showWebsiteAlert(_:)), for: .touchUpInside)
        default:
            print("TextField not found")
        }

        textField.rightView = button
    }

    private func setupSubscriberEvent() {
        viewModel.isShowingData.sink { [weak self] status in
            if status {
                self?.showProfileData()
            }
        }
        .store(in: &cancellables)

        viewModel.profileUpdated.sink { [weak self] status in
            if status {
                self?.profileUpdated()
            }
        }
        .store(in: &cancellables)
    }

    private func setupSubscriberForm() {
        let namePublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
            .map { ($0.object as? UITextField)?.text }
            .replaceNil(with: "")
            .map { !$0.isEmpty }
        namePublisher.sink { [weak self] value in
            self?.nameTextField.rightViewMode = value ? .never : .always
        }
        .store(in: &cancellables)

        let websitePublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: websiteTextField)
            .map { ($0.object as? UITextField)?.text }
            .replaceNil(with: "")
            .map { !$0.isEmpty }
        websitePublisher.sink { [weak self] value in
            self?.websiteTextField.rightViewMode = value ? .never : .always
        }
        .store(in: &cancellables)

        let savePublisher = Publishers.Merge(namePublisher, websitePublisher)
        savePublisher.sink { [weak self] isValid in
            if isValid {
                self?.saveButton.isEnabled = true
                self?.saveButton.tintColor = UIColor.tintColor
            } else {
                self?.saveButton.isEnabled = false
                self?.saveButton.tintColor = UIColor.systemGray
            }
        }
        .store(in: &cancellables)
    }

    private func profileUpdated() {
        let alert = UIAlertController(
            title: "success_info".localized(),
            message: "profile_updated".localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.saveCallback?()
        })
        present(alert, animated: true, completion: nil)
    }

    private func showProfileData() {
        if let profileData = viewModel.profileData {
            if let image = profileData.image {
                profileImage.image = UIImage(data: image)
            }
            nameTextField.text = profileData.name
            websiteTextField.text = profileData.website
        }
    }

    @objc func backButtonPressed() {
        dismissCallback?()
    }

    @objc func saveButtonPressed() {
        let name = nameTextField.text ?? ""
        let website = websiteTextField.text ?? ""

        if let image = profileImage.image, let imageData = image.pngData() {
            viewModel.saveProfile(imageData, name, website)
        }
    }

    @IBAction func selectImage(_: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func showNameAlert(_: Any) {
        let alertController = UIAlertController(
            title: "warning_info".localized(),
            message: "name_required".localized(),
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }

    @objc func showWebsiteAlert(_: Any) {
        let alertController = UIAlertController(
            title: "warning_info".localized(),
            message: "website_required".localized(),
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Failed",
                message: "Image can't be loaded.",
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
