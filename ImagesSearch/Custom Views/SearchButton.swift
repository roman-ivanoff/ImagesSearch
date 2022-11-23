//
//  SearchButton.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class SearchButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 5
    }
}

