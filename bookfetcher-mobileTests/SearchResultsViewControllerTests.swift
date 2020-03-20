//
//  SearchResultsViewControllerTests.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/19/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import XCTest
@testable import bookfetcher_mobile

class SearchResultsViewControllerTest: XCTestCase {
    
    var systemUnderTest: SearchResultsViewController!
    
    override func setUp() {
        super.setUp()
        systemUnderTest = SearchResultsViewController()
    }
    
    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }
    
    func testPrepareForSearch() {
        systemUnderTest.books = [.mock()]
        systemUnderTest.loadingView.isHidden = true
        systemUnderTest.noResultsView.isHidden = false
        systemUnderTest.errorView.isHidden = false
    
        systemUnderTest.prepareForSearch()
        
        XCTAssert(systemUnderTest.books.isEmpty, "it clears the books")
        XCTAssert(systemUnderTest.loadingView.isHidden == false, "it shows the loading view")
        XCTAssert(systemUnderTest.noResultsView.isHidden == true, "it hides the no results view")
        XCTAssert(systemUnderTest.errorView.isHidden == true, "it hides the error view")
        
    }
    
    func testClearSearch() {
        systemUnderTest.books = [.mock()]
        systemUnderTest.loadingView.isHidden = true
        systemUnderTest.noResultsView.isHidden = false
        systemUnderTest.errorView.isHidden = false
    
        systemUnderTest.clearSearch()
        
        XCTAssert(systemUnderTest.books.isEmpty, "it clears the books")
        XCTAssert(systemUnderTest.loadingView.isHidden == true, "it does not hide the loading view")
        XCTAssert(systemUnderTest.noResultsView.isHidden == true, "it hides the no results view")
        XCTAssert(systemUnderTest.errorView.isHidden == true, "it hides the error view")
    }
    
    func testHandleAResultOfBooks() {
        let books = [Book.mock()]
        let result = Result<[Book], Error>.success(books)
        systemUnderTest.books = [.mock()]
        systemUnderTest.loadingView.isHidden = false
        
        systemUnderTest.handle(result: result)
        
        XCTAssert(systemUnderTest.books.count == 2, "it concats returned books to its existing books")
        XCTAssert(systemUnderTest.loadingView.isHidden == true, "it hides the loading view")
    }
    
    func testHandleEmptyResult() {
        let books = [Book]()
        let result = Result<[Book], Error>.success(books)
        systemUnderTest.loadingView.isHidden = false
        systemUnderTest.noResultsView.isHidden = true
        systemUnderTest.handle(result: result)
        
        XCTAssert(systemUnderTest.loadingView.isHidden == true, "it hides the loading view")
        XCTAssert(systemUnderTest.noResultsView.isHidden == false, "it shows the no results view ")
        
    }
    
    func testHandleConnectivityError() {
        let error = buildNewError(code: -1009, description: "Twas a mock error.")
        let result = Result<[Book], Error>.failure(error)

        systemUnderTest.errorView.isHidden = true
        systemUnderTest.handle(result: result)
        
        XCTAssert(systemUnderTest.errorView.isHidden == false, "it shows the error view")
        XCTAssertEqual(systemUnderTest.errorView.label.text, "Twas a mock error.", "it displays the localized description of the error")
    }
    
    func testHandlesOtherError() {
          let error = buildNewError(code: 8888, description: "Any other error")
          let result = Result<[Book], Error>.failure(error)

          systemUnderTest.errorView.isHidden = true

          systemUnderTest.handle(result: result)
          

          XCTAssert(systemUnderTest.noResultsView.isHidden == false, "it shows the error view")
    }
    
}

extension Book {
    static func mock(title: String = "We Have Always Lived in the Castle",
                     authors: [String]? = ["Shirley Jackson"],
                     imageLinks: [String: URL]? = nil,
                     publisher: String? = nil) -> Book {
        let volumeInfo = VolumeInfo(title: title, authors: authors, imageLinks: imageLinks, publisher: publisher)
        return Book(volumeInfo: volumeInfo)
    }
}

private func buildNewError(code: Int, description: String) -> NSError {
    return NSError(domain: "com.monica.whatever", code: code, userInfo: [
      NSLocalizedDescriptionKey: description
    ])
}

struct MockError: Error, Equatable {}

