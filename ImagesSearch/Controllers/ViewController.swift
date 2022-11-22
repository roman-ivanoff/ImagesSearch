//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 22.11.2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundOverlay()
    }

    // MARK: - Custom Methods
    private func addBackgroundOverlay() {
        backgroundImage.addoverlay(color: .black, alpha: 0.55)
    }
}
