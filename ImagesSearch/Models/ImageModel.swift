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
    var isLoading = false

    func getImage(
        imageId: String,
        onSuccess: @escaping([ImageHit]) -> Void,
        onError: @escaping(ServiceError) -> Void
    ) {
        isLoading = true

        imageHitService.getImages(imageId: imageId) { [weak self] (result: Result<PixabayImages, ServiceError>) in
            guard let self else {
                return
            }

            switch result {
            case let .success(data):
                self.images = data.hits
                self.isLoading = false
                onSuccess(data.hits)
            case let .failure(error):
                self.isLoading = false
                onError(error)
            }
        }
    }

    func getImageFormat() -> String {
        return (images[0].largeImageURL as NSString).pathExtension.uppercased()
    }
}
