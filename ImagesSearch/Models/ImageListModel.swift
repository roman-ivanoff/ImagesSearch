//
//  ImageListModel.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 01.12.2022.
//

import Foundation

class ImageListModel {
    var images: [ImageHit] = []
    var hits = 0
    var page = 0
    let perPage = 20
    let imageHitService = ImagesHitService()

    func getImages(
        searchTerm: String,
        imageType: ImageType,
        onSucces: @escaping([ImageHit]) -> Void,
        onError: @escaping(ServiceError) -> Void
    ) {
        imageHitService.getImages(
            searchTerm: searchTerm,
            imageType: imageType
        ) { [weak self] (result: Result<PixabayImages, ServiceError>) in
            guard let self else {
                return
            }

            switch result {
            case let .success(data):
                self.images = data.hits
                self.hits = data.total
                onSucces(data.hits)
            case let .failure(error):
                onError(error)
            }
        }
    }
}