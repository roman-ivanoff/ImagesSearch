//
//  ImagesHitService.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 30.11.2022.
//

import Foundation

class ImagesHitService {
    var session: URLSession
    let link = "https://pixabay.com/api/?"
    let key = "23684271-dff55bff8aa1d9e8b261498c9"
    let searchTermName = "q"
    let imageIdName = "id"
    let imageTypeName = "image_type"
    var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getImages<T: Decodable>(
        ofType: T.Type,
        searchTerm: String? = nil,
        imageId: String? = nil,
        imageType: ImageType? = nil,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
        completion: @escaping(Result<T, ServiceError>) -> Void
    ) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: link) {
            var queryItems: [URLQueryItem] = [URLQueryItem(name: "key", value: key)]

            if let searchTerm = searchTerm, !searchTerm.isEmpty {
                queryItems.append(URLQueryItem(name: searchTermName, value: searchTerm))
            }
            if let imageId = imageId, !imageId.isEmpty {
                queryItems.append(URLQueryItem(name: imageIdName, value: imageId))
            }
            if let imageType = imageType {
                queryItems.append(URLQueryItem(name: imageTypeName, value: imageType.apiOption))
            }

            urlComponents.queryItems = queryItems

            guard let url = urlComponents.url else {
                completion(.failure(.invalidUrl))
                return
            }
            print(url)
        }

        print("----------------------------")

        dataTask?.resume()
    }
}
