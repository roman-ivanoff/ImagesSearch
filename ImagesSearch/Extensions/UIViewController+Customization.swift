//
//  UIViewController+Customization.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 25.12.2022.
//

import UIKit
import CropViewController

extension UIViewController {
    func cropImage(image: UIImage, delegate: CropViewControllerDelegate) {
        let cropVC = CropViewController(croppingStyle: .default, image: image)
        cropVC.aspectRatioPreset = .presetSquare
        cropVC.aspectRatioLockEnabled = false
        cropVC.toolbarPosition = .bottom
        cropVC.doneButtonTitle = "Save"
        cropVC.cancelButtonTitle = "Cancel"
        cropVC.delegate = delegate
        present(cropVC, animated: true)
    }

    func showErrorAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
        dialogMessage.addAction(okAction)
        present(dialogMessage, animated: true)
    }

    @objc func imageAlert(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if let error = error {
            showErrorAlert(
                title: NSLocalizedString("error", comment: ""),
                message: error.localizedDescription
            )
        } else {
            showErrorAlert(
                title: NSLocalizedString("success", comment: ""),
                message: NSLocalizedString("image_saved", comment: "")
            )
        }
    }
}
