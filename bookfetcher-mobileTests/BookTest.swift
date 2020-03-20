//
//  BookTest.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/19/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import XCTest
@testable import bookfetcher_mobile

class BookTest: XCTestCase {

    func testTitle() {
        // arrange
        let expectedTitle = "The Bird's Nest"
        let book = Book.mock(title: expectedTitle)
        
        // assert
        XCTAssertEqual(book.title, expectedTitle, "it uses the title from the volume info")
    }
    
    func testAuthors() {
        // arrange
        let multipleAuthors = ["Shirley Jackson", "Shirley Jackson"]
        let multipleAuthorsBook = Book.mock(authors: multipleAuthors)
        let publisher = "Random House"
        let noAuthorBook = Book.mock(authors: nil, publisher: publisher)
        let singleAuthor = ["Shirley Jackson"]
        let singleAuthorBook = Book.mock(authors: singleAuthor)
        let noAuthorNoPubisherBook = Book.mock(authors: nil, publisher: nil)
        
        // assert
        XCTAssertEqual(multipleAuthorsBook.authors, "Shirley Jackson, Shirley Jackson", "it joins authors when there are multiple")
        XCTAssertEqual(noAuthorBook.authors, "Random House", "it displays the publisher when there are no listed authors")
        XCTAssertEqual(singleAuthorBook.authors, "Shirley Jackson", "it uses author from volume info when available")
        XCTAssertEqual(noAuthorNoPubisherBook.authors, "", "it assigns an empty string if there are no authors or publisher returned")
    }
    
    func testThumbNailImageURL() {
        // arrange
        let url = URL(string: "www.googleybooks.com")!
        let bookWithThumbnail = Book.mock(imageLinks: ["thumbnail": url])
        let bookWithoutThumbnail = Book.mock()
        
        // assert
        XCTAssertEqual(bookWithThumbnail.thumbnailImageURL, url, "it unwraps the URL from the dictionary in volumeInfo")
        XCTAssertEqual(bookWithoutThumbnail.thumbnailImageURL, nil, "it returns nil if there's no image url")
    }
    
}
