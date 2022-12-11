//
//  NIBAble.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 11.12.2022.
//

import UIKit

protocol NIBAble: SMIdentifiable {
    static var nib: UINib { get }
}

extension NIBAble {
    static var nib: UINib { UINib(nibName: identifier, bundle: nil) }
}
