//
//  ImageModel.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 05.12.2022.
//

import Foundation

class ImageModel {
    var id: String = "1"
    var images: [ImageHit] = []
    let imageHitService = ImagesHitService()
    var relatedImages: [ImageHit] = []

    func getImage(
        imageId: String,
        onSuccess: @escaping([ImageHit]) -> Void,
        onError: @escaping(ServiceError) -> Void
    ) {
        imageHitService.getImages(imageId: imageId) { [weak self] (result: Result<PixabayImages, ServiceError>) in
            guard let self else {
                return
            }

            switch result {
            case let .success(data):
                self.images = data.hits
                onSuccess(data.hits)
            case let .failure(error):
                onError(error)
            }
        }
    }

    func getImageFormat() -> String {
        return URL(string: images[0].largeImageURL)!.pathExtension.uppercased()
    }
}
