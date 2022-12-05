//
//  ImageDetailViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import UIKit

class ImageDetailViewController: UIViewController {
    var id: String!
    var images: [ImageHit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------- \(id)")
        print(images.count)

        view.backgroundColor = .red
    }
}
