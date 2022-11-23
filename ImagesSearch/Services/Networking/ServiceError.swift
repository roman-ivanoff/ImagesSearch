//
//  ServiceError.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case invalidUrl
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
}
