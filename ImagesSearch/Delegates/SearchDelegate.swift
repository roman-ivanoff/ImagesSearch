//
//  SearchDelegate.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 05.12.2022.
//

import Foundation

class SearchDelegate: NSObject {
    private let searchImages: (String) -> Void
    private var workItem: DispatchWorkItem?

    init(searchImages: @escaping(String) -> Void) {
        self.searchImages = searchImages
        super.init()
    }

    @objc func editingChanged(_ sender: SearchTextField) {
        workItem?.cancel()
        let workItem = DispatchWorkItem { [self] in
            guard let text = sender.text else {
                return
            }
            self.searchImages(text)
         }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
    }
}
