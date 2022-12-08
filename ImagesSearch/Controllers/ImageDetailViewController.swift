//
//  ImageDetailViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    @IBOutlet weak var shareButton: ShareButton!
    @IBOutlet weak var downloadButton: SearchButton!
    @IBOutlet weak var apiLicenseLabel: UILabel!
    @IBOutlet weak var noAttributionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var imageFormatLabel: UILabel!
    @IBOutlet weak var zoomButton: UIButton!

    // MARK: - Properties
    let imageModel = ImageModel()
    let cellId = "imageCell"

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    // MARK: - Custom Methods

    // MARK: - Actions
    @IBAction func zoomImageAction(_ sender: UIButton) {
    }
    
    @IBAction func downloadImageAction(_ sender: SearchButton) {
    }

    @IBAction func shareImageAction(_ sender: ShareButton) {
    }
}
