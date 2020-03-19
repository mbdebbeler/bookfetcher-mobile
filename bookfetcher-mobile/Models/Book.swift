//
//  Book.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

struct Book: Decodable {
    struct VolumeInfo: Decodable {
        let title: String
        let authors: [String]?
        let imageLinks: [String: URL]?
        let publisher: String?
    }
    let volumeInfo: VolumeInfo
    var title: String {
        return volumeInfo.title
    }
    var authors: String {
        return volumeInfo.authors?.joined(separator: ", ") ?? volumeInfo.publisher ?? ""
    }
    var thumbnailImageURL: URL? {
        return volumeInfo.imageLinks?["thumbnail"]
    }
}

struct BookResponse: Decodable {
    let items: [Book]?
    let totalItems: Int
}
