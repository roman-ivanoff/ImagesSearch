//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 22.11.2022.
//

import UIKit
import DropDown

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var searchButton: SearchButton!
    @IBOutlet weak var freePhotoLabel: UILabel!
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var backgroundImage: UIImageView!

    // MARK: - Properties
    let dropDown = DropDown()
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
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

    @IBAction func searchAction(_ sender: Any) {
        guard let searchQuery = searchTextField.text,
              !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        print("\(searchQuery), \(imageType)")

        imageModel.getImages(searchTerm: searchQuery, imageType: imageType) { result in
            print("////////////--------------------------------------")
            print(result)
        } onError: { error in
            print(error)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
