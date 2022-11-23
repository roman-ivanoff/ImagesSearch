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
        alignmentImageRight()
        tintColor = UIColor(named: "nightRiderColor")
        setTitleColor(UIColor(named: "nightRiderColor"), for: .normal)
        titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 14)
    }
}
