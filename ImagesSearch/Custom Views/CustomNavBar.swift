//
//  CustomNavBar.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 18.12.2022.
//

import UIKit

class CustomNavBar: UIView {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initUIView()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initUIView()
        setup()
    }

    private func initUIView() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = self.bounds
        addSubview(view)
    }

    private func setup() {
        backButton.layer.cornerRadius = 5

        settingsButton.layer.borderColor = UIColor(named: "textFieldColor")?.cgColor
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.cornerRadius = 5

        textField.backgroundColor = UIColor(named: "lightGrayColor")
        textField.placeholder = NSLocalizedString("textfield_placeholder", comment: "")
    }

}
