//
//  ImageDetailViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var shareButton: ShareButton!
    @IBOutlet weak var apiLicenseLabel: UILabel!
    @IBOutlet weak var noAttributionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var imageFormatLabel: UILabel!
    @IBOutlet weak var zoomButton: UIButton!
    let imageModel = ImageModel()
    let cellId = "imageCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
    
    @IBAction func zoomImageAction(_ sender: UIButton) {
    }
    
    @IBAction func shareImageAction(_ sender: ShareButton) {
    }
}
