//
//  UIView+Overlay.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 22.11.2022.
//

import UIKit

extension UIView {
func addoverlay(color: UIColor = .black, alpha: CGFloat = 0.6) {
    let overlay = UIView()
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.frame = bounds
    overlay.backgroundColor = color
    overlay.alpha = alpha
    addSubview(overlay)
    }
}
