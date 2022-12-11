//
//  ImageCollectionViewCell.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 04.12.2022.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell, NIBAble {
    @IBOutlet weak var imageView: UIImageView!
    static let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    @IBOutlet weak var shareButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(url: URL, isHideButton: Bool) {
        let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: resource,
            options: [
                .processor(RoundCornerImageProcessor(cornerRadius: 5)),
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .transition(.fade(0.7)),
                .cacheOriginalImage
            ]
        ) { result in
                switch result {
                case .success:
                    if isHideButton {
                        self.shareButton.isHidden = true
                    } else {
                        self.shareButton.isHidden = false
                    }
                case .failure:
                    self.shareButton.isHidden = true
                }
            }

        imageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        shareButton.isHidden = true
    }

}
