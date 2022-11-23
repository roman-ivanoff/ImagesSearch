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
    var dropDownButton: DropdownButton!
    let imageTypes: [ImageType] = [.all, .photo, .illustration, .vector]

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

        searchTextField.placeholder = NSLocalizedString("textfield_placeholder", comment: "")
        searchTextField.rightView?.frame = searchTextField.rightViewRect(forBounds: searchTextField.bounds)
        setupDropdownButton()
        searchTextField.rightView = dropDownButton
        searchTextField.rightViewMode = .always
    }

    private func setupDropdownButton() {
        dropDownButton = DropdownButton(frame: CGRect(x: 0, y: 0, width: 50, height: searchTextField.frame.height))
        dropDownButton.setTitle(imageTypes[1].name, for: .normal)
        dropDownButton.drawBorder(edges: [.left], borderWidth: 1, color: UIColor(named: "lineGrayColor")!, margin: 0)
        dropDownButton.addTarget(self, action: #selector(selectImageTypeAction(_:)), for: .touchUpInside)
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
            sender.isRotated.toggle()
            sender.setTitle(item, for: .normal)
        }
        dropDown.cancelAction = {
            sender.isRotated.toggle()
        }
    }

    @IBAction func searchAction(_ sender: Any) {
    }
}
