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
    var page = 1
    let perPage = 20
    let imageHitService = ImagesHitService()
    var searchTerm = ""
    var imageType: ImageType = .photo

    func getImages(
        searchTerm: String,
        imageType: ImageType,
        page: String,
        perPage: String,
        onSucces: @escaping([ImageHit]) -> Void,
        onError: @escaping(ServiceError) -> Void
    ) {
        imageHitService.getImages(
            searchTerm: searchTerm,
            imageType: imageType,
            page: page,
            perPage: perPage
        ) { [weak self] (result: Result<PixabayImages, ServiceError>) in
            guard let self else {
                return
            }

            switch result {
            case let .success(data):
                self.images.append(contentsOf: data.hits)
                self.hits = data.total
                onSucces(data.hits)
            case let .failure(error):
                onError(error)
            }
        }
    }

    func canLoadImages() -> Bool {
        return  page * perPage <= hits
    }

    func getRelatedImages(image: ImageHit, images: [ImageHit]) -> [ImageHit] {
        let imagesWithoutImage = images.filter { $0.id != image.id}
        return imagesWithoutImage.count < perPage ?
        imagesWithoutImage :
        Array(imagesWithoutImage.prefix(perPage))
    }
}
