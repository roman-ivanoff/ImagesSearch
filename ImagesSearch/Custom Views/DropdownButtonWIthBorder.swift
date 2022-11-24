//
//  DropdownButtonWIthBorder.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 24.11.2022.
//

import UIKit

// swiftlint:disable: force_cast
class DropdownButtonWIthBorder: UIView {
    let contentXibName = "DropdownButtonWIthBorder"

    @IBOutlet weak var button: DropdownButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        let viewFromXib = Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)!.first as! UIView
        viewFromXib.translatesAutoresizingMaskIntoConstraints = false
        viewFromXib.frame = self.frame
        addSubview(viewFromXib)
        viewFromXib.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewFromXib.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        viewFromXib.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewFromXib.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
