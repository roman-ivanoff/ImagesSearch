//
//  PixabayImages.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 23.11.2022.
//

import Foundation

struct PixabayImages: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ImageHit]
}
