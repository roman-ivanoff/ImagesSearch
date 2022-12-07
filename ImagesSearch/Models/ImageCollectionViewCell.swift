//
//  ImageCollectionViewCell.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 04.12.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    static let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    
    @IBOutlet weak var shareButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
