//
//  DropdownButton.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class DropdownButton: UIButton {
    var isRotated = false {
        didSet {
            if isRotated {
                UIView.animate(withDuration: 0.4) {
                    self.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.imageView?.transform = CGAffineTransform(rotationAngle: .pi * 2)
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "textFieldColor")
        setImage(UIImage(named: "arrow"), for: .normal)
        semanticContentAttribute = .forceRightToLeft
        backgroundColor = UIColor(named: "textFieldColor")
        tintColor = UIColor(named: "nightRiderColor")
        setTitleColor(UIColor(named: "nightRiderColor"), for: .normal)
        titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 14)
        titleLabel?.numberOfLines = 1
        titleLabel?.lineBreakMode = .byTruncatingHead
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
    }
}
