//
//  UICollectionView+Configuration.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 08.12.2022.
//

import UIKit

extension UICollectionView {
    func registerCustomCell(_ cell: NIBAble.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
    }
}
