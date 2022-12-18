//
//  SearchTermSendingDelegate.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 18.12.2022.
//

import Foundation

protocol SearchTermSendingDelegate: AnyObject {
    func sendSearchTerm(searchTerm: String)
}
