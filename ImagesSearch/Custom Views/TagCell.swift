//
//  TagCell.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 21.12.2022.
//

import UIKit

class TagCell: UICollectionViewCell, NIBAble {

    @IBOutlet weak var labelTag: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}
