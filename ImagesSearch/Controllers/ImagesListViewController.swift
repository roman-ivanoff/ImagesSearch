//
//  ImagesListViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    // MARK: - Properties
    var searchQuery: String!
    var imageType: ImageType!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }

}
