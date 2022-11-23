//
//  ImageType.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import Foundation

enum ImageType: String, Codable {
    case all
    case photo
    case illustration
    case vector

    var name: String {
        switch self {
        case .all:
            return NSLocalizedString("all", comment: "")
        case .photo:
            return NSLocalizedString("photo", comment: "")
        case .illustration:
            return NSLocalizedString("illustration", comment: "")
        case .vector:
            return NSLocalizedString("vector", comment: "")
        }
    }

    var apiOption: String {
        return self.rawValue
    }
}
