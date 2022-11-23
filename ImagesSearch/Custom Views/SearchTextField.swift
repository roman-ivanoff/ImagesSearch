//
//  SearchTextField.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class SearchTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 100, y: 0, width: 90, height: bounds.height)
    }

    private func setup() {
        backgroundColor = UIColor(named: "textFieldColor")
        font = UIFont(name: "OpenSans-Regular", size: 14)
        attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "textFieldFontColor")!]
        )

        addLeftImage()
    }

    private func addLeftImage() {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 0, width: 14, height: 14))
        let image = UIImage(named: "searchIconTextField")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 14))
        imageContainerView.addSubview(imageView)

        leftView = imageContainerView
        leftViewMode = .always
    }
}
