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
    }
    let volumeInfo: VolumeInfo
    var title: String {
        return volumeInfo.title
    }
}

struct BookResponse: Decodable {
    let items: [Book]?
}

