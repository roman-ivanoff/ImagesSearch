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
    let pageName = "page"
    let perPageName = "per_page"
    var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func getImages<T: Decodable>(
        searchTerm: String? = nil,
        imageId: String? = nil,
        imageType: ImageType? = nil,
        page: String? = nil,
        perPage: String? = nil,
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
            if let page = page, !page.isEmpty {
                queryItems.append(URLQueryItem(name: pageName, value: page))
            } else {
                queryItems.append(URLQueryItem(name: pageName, value: "1"))
            }
            if let perPage = perPage, !perPage.isEmpty {
                queryItems.append(URLQueryItem(name: perPageName, value: perPage))
            } else {
                queryItems.append(URLQueryItem(name: perPageName, value: "20"))
            }

            urlComponents.queryItems = queryItems

            guard let url = urlComponents.url else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidUrl))
                }
                return
            }

            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponseStatus))
                    }
                    return
                }

                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(.failure(.dataTaskError(error!.localizedDescription)))
                    }
                    return
                }

                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.corruptData))
                    }
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = keyDecodingStrategy

                do {
                    let decodedData = try decoder.decode(T.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error.localizedDescription)))
                    }
                }
            })
        }

        dataTask?.resume()
    }
}
