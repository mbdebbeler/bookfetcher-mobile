//
//  BookStore.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

class BookStore {
    private let books = Array((0..<100)).map { (i: Int) -> Book in
        return Book(title: "World Book vol. \(i)")
    }
    
    func getBooks() -> [Book] {
        return books
    }
     
    //local version, no networking needed. checks a query against a list of book titles
    func search(query: String) -> [Book] {
        return books.filter {(book: Book) -> Bool in
            book.title == query
        }
    }
}
