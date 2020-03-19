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
        // arrange
        systemUnderTest.books = [.mock()]
        systemUnderTest.loadingView.isHidden = true
        systemUnderTest.noResultsView.isHidden = false
        systemUnderTest.errorView.isHidden = false
        
        // act
        systemUnderTest.prepareForSearch()
        
        // asserts
        XCTAssert(systemUnderTest.books.isEmpty, "it clears the books")
        XCTAssert(systemUnderTest.loadingView.isHidden == false, "it shows the loading view")
        XCTAssert(systemUnderTest.noResultsView.isHidden == true, "it hides the no results view")
        XCTAssert(systemUnderTest.errorView.isHidden == true, "it hides the error view")
        
    }
    
    func testHandleAResultOfBooks() {
        // arrange
        let books = [Book.mock()]
        let result = Result<[Book], Error>.success(books)
        systemUnderTest.books = [.mock()]
        systemUnderTest.loadingView.isHidden = false
        

        // act
        systemUnderTest.handle(result: result)
        
        // assert
        XCTAssert(systemUnderTest.books.count == 2, "it concats returned books to its existing books")
        XCTAssert(systemUnderTest.loadingView.isHidden == true, "it hides the loading view")
    }
    
    func testHandleEmptyResult() {
        // arrange
        let books = [Book]()
        let result = Result<[Book], Error>.success(books)
        systemUnderTest.loadingView.isHidden = false
        systemUnderTest.noResultsView.isHidden = true

        // act
        systemUnderTest.handle(result: result)
        
        // assert
        XCTAssert(systemUnderTest.loadingView.isHidden == true, "it hides the loading view")
        XCTAssert(systemUnderTest.noResultsView.isHidden == false, "it shows the no results view ")
        
    }
    
    func testHandleConnectivityError() {
        // arrange
        let error = buildNewError(code: -1009, description: "Twas a mock error.")
        let result = Result<[Book], Error>.failure(error)

        systemUnderTest.errorView.isHidden = true

        // act
        systemUnderTest.handle(result: result)
        
        // assert
        XCTAssert(systemUnderTest.errorView.isHidden == false, "it shows the error view")

        XCTAssertEqual(systemUnderTest.errorView.label.text, "Twas a mock error.", "it displays the localized description of the error")
    }
    
    func testHandlesOtherError() {
        // arrange
          let error = buildNewError(code: 8888, description: "Any other error")
          let result = Result<[Book], Error>.failure(error)

          systemUnderTest.errorView.isHidden = true

          // act
          systemUnderTest.handle(result: result)
          
          // assert
          XCTAssert(systemUnderTest.noResultsView.isHidden == false, "it shows the error view")
    }
    
    func testTableViewNumberOfRowsInSection() {
        // arrange
        systemUnderTest.books = [.mock()]
        let expected = systemUnderTest.books.count

        // act
        let actual = systemUnderTest.tableView(UITableView(), numberOfRowsInSection: 0)
        
        // assert
        XCTAssert(actual == expected, "tableView has 1 row")
    }
    
    func testTableViewNumberOfSections() {
        // arrange
        let expected = 1

        // act
        let actual = systemUnderTest.numberOfSections(in: UITableView())
        
        // assert
        XCTAssert(actual == expected, "tableView has 1 section")
    }
    
    func testTableViewHeight() {
        // arrange
        let expected: CGFloat = 100
        systemUnderTest.books = [.mock()]
        
        // act
        let actual = systemUnderTest.tableView(UITableView(), heightForRowAt: [0,1])
        
        // assert
        XCTAssert(actual == expected, "it makes cells that are 100px in height")
    }
    
    func testCellForRowAt() {
        // arrange
        let expectedAuthor = "Shirley Jackson"
        let expectedTitle = "We Have Always Lived in the Castle"
        let expectedImage = UIImage(named: "sad")
        systemUnderTest.books = [.mock()]
        let tableView = UITableView()
        tableView.register(BookCell.self, forCellReuseIdentifier: String(describing: BookCell.self))
        
        // act
        let actualCell: BookCell
        actualCell = systemUnderTest.tableView(tableView, cellForRowAt: [0,0]) as! BookCell
        let actualAuthor = actualCell.authorLabel.text
        let actualTitle = actualCell.titleLabel.text
        let actualImage = actualCell.thumbnailImageView.image
        
        
        // assert
        XCTAssert(actualAuthor == expectedAuthor, "it formats the cell with book author")
        XCTAssert(actualTitle == expectedTitle, "it formats the cell with book title")
        XCTAssert(actualImage == expectedImage, "it renders a placeholder image")
    }
    
    func testScrollViewDidScrollToBottom() {
        // arrange
        let scrollView = UIScrollView()
        let delegate = MockSearchResultsViewControllerDelegate()
        systemUnderTest.delegate = delegate
        scrollView.frame.size.height = 10
        scrollView.contentOffset.y = 11
        scrollView.contentSize.height = 21
        
        // act
        systemUnderTest.scrollViewDidScroll(scrollView)
        
        // assert
        XCTAssertEqual(delegate.didScrollToBottomWasCalled, true, "it triggers the delegate when you scroll to the bottom")
    }
    
    func testScrollViewDidScrollNotAllTheWayToBottom() {
        // arrange
        let scrollView = UIScrollView()
        let delegate = MockSearchResultsViewControllerDelegate()
        systemUnderTest.delegate = delegate
        scrollView.frame.size.height = 10
        scrollView.contentOffset.y = 0
        scrollView.contentSize.height = 11
        
        // act
        systemUnderTest.scrollViewDidScroll(scrollView)
        
        // assert
        XCTAssertEqual(delegate.didScrollToBottomWasCalled, false, "it does not trigger the delegate when you scroll not all the way to the bottom")
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

struct MockError: Error {
    let _code: Int
    let localizedDescription: String
}

class MockSearchResultsViewControllerDelegate: SearchResultsViewControllerDelegate {
    
    var didScrollToBottomWasCalled = false
    
    func didScrollToBottom() {
        didScrollToBottomWasCalled = true
    }
}

