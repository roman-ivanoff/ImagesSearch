//
//  ShareButton.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 08.12.2022.
//

import UIKit

class ShareButton: UIButton {
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
        backgroundColor = .white
        setImage(UIImage(named: "share"), for: .normal)
        tintColor = UIColor(named: "nightRiderColor")
        setTitleColor(UIColor(named: "nightRiderColor"), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "blueColor")?.cgColor
        layer.cornerRadius = 5
    }
}
