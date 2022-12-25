//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 22.11.2022.
//

import UIKit
import DropDown
import CropViewController

// swiftlint:disable: force_cast
class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var searchButton: SearchButton!
    @IBOutlet weak var freePhotoLabel: UILabel!
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var backgroundImage: UIImageView!

    // MARK: - Properties
    let dropDown = DropDown()
    let picker = UIImagePickerController()
    var dropdownButtonWIthBorder: DropdownButtonWIthBorder!
    let imageTypes: [ImageType] = [.all, .photo, .illustration, .vector]
//    var imageType = ImageType.photo.apiOption
    var imageType = ImageType.photo

    let imageModel = ImageListModel()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Overrided Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Custom Methods
    private func addBackgroundOverlay() {
        backgroundImage.addoverlay(color: .black, alpha: 0.55)
    }

    private func setupViews() {
        addBackgroundOverlay()

        searchButton.setTitle(NSLocalizedString("search", comment: ""), for: .normal)

        freePhotoLabel.text = NSLocalizedString("free_photos", comment: "")

        searchTextField.delegate = self
        searchTextField.placeholder = NSLocalizedString("textfield_placeholder", comment: "")
        searchTextField.rightView?.frame = searchTextField.rightViewRect(forBounds: searchTextField.bounds)
        setupDropdownButton()
        searchTextField.rightView = dropdownButtonWIthBorder
        searchTextField.rightViewMode = .always
    }

    private func setupDropdownButton() {
        dropdownButtonWIthBorder = DropdownButtonWIthBorder(frame: CGRect(x: 0, y: 0, width: 90, height: 52))
        dropdownButtonWIthBorder.button.setTitle(imageTypes[1].name, for: .normal)
        dropdownButtonWIthBorder.button.addTarget(
            self,
            action: #selector(selectImageTypeAction(_:)),
            for: .touchUpInside
        )
    }

//    private func showErrorAlert(title: String, message: String) {
//        let dialogMessage = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: .alert
//        )
//        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
//        dialogMessage.addAction(okAction)
//        present(dialogMessage, animated: true)
//    }

    // MARK: - Actions
    @objc func selectImageTypeAction(_ sender: DropdownButton) {
        sender.isRotated.toggle()

        dropDown.dataSource = imageTypes.map {$0.name}
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] ( index: Int, item: String ) in
            guard let self else {
                return
            }
//            self.imageType = self.imageTypes[index].apiOption
            self.imageType = self.imageTypes[index]
            sender.isRotated.toggle()
            sender.setTitle(item, for: .normal)
        }
        dropDown.cancelAction = {
            sender.isRotated.toggle()
        }
    }

    @IBAction func openPhotoLibraryAction(_ sender: SearchButton) {
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func searchAction(_ sender: Any) {
        guard let searchQuery = searchTextField.text,
              !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showErrorAlert(
                title: NSLocalizedString("error", comment: ""),
                message: NSLocalizedString("error_message", comment: "")
            )
            return
        }

        let storyboard = UIStoryboard(name: "ImagesList", bundle: nil)
        let imagesListVC = storyboard
            .instantiateViewController(withIdentifier: "imagesList") as! ImagesListViewController
        imagesListVC.imageModel.searchTerm = searchQuery
        imagesListVC.imageModel.imageType = imageType
        self.navigationController?.pushViewController(imagesListVC, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UINavigationControllerDelegate {
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)

        cropImage(image: image, delegate: self)
    }
}

extension ViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
        present(picker, animated: true)
    }

    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int
    ) {
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(imageAlert(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
        cropViewController.dismiss(animated: true)
        present(picker, animated: true)
    }
}
