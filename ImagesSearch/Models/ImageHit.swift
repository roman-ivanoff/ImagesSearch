//
//  ImageHit.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import Foundation

struct ImageHit {
    let id: Int
    let pageURL: String
    let type: ImageType
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let views: Int
    let downloads: Int
    let collections: Int
    let likes: Int
    let comments: Int
    let userID: Int
    let user: String
    let userImageURL: String
}
