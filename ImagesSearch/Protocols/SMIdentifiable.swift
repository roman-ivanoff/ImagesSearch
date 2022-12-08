//
//  SMIdentifiable.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 08.12.2022.
//

import UIKit

public protocol SMIdentifiable {
    static var identifier: String { get }
    var identifier: String { get }

    static var nib: UINib { get }
    var nib: UINib { get }
}

extension SMIdentifiable {
    static var identifier: String { String(describing: self) }
    var identifier: String { Self.identifier }

    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    var nib: UINib { Self.nib }
}
