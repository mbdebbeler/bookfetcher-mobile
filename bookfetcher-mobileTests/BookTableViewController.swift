//
//  BookTableViewController.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/24/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import XCTest
@testable import bookfetcher_mobile

class BookTableViewControllerTest: XCTestCase {
    
    var systemUnderTest: BookTableViewController!
    
    override func setUp() {
        super.setUp()
        systemUnderTest = BookTableViewController()
    }
    
    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }
    
    func testTableViewNumberOfRowsInSection() {
        systemUnderTest.books = [.mock()]
        let expected = systemUnderTest.books.count
        
        let actual = systemUnderTest.tableView(UITableView(), numberOfRowsInSection: 0)
        
        XCTAssert(actual == expected, "tableView has 1 row")
    }
    
    func testTableViewNumberOfSections() {
        let expected = 1
        
        let actual = systemUnderTest.numberOfSections(in: UITableView())
        
        XCTAssert(actual == expected, "tableView has 1 section")
    }
    
    func testTableViewHeight() {
        let expected: CGFloat = 100
        systemUnderTest.books = [.mock()]
        
        let actual = systemUnderTest.tableView(UITableView(), heightForRowAt: [0,1])
        
        XCTAssert(actual == expected, "it makes cells that are 100px in height")
    }
    
    func testCellForRowAt() {
        let expectedAuthor = "Shirley Jackson"
        let expectedTitle = "We Have Always Lived in the Castle"
        let expectedImage = UIImage(systemName: "book.circle.fill")
        systemUnderTest.books = [.mock()]
        let tableView = UITableView()
        tableView.register(BookCell.self, forCellReuseIdentifier: String(describing: BookCell.self))
        
        let actualCell: BookCell
        actualCell = systemUnderTest.tableView(tableView, cellForRowAt: [0,0]) as! BookCell
        let actualAuthor = actualCell.authorLabel.text
        let actualTitle = actualCell.titleLabel.text
        let actualImage = actualCell.thumbnailImageView.image
        
        
        XCTAssert(actualAuthor == expectedAuthor, "it formats the cell with book author")
        XCTAssert(actualTitle == expectedTitle, "it formats the cell with book title")
        XCTAssert(actualImage == expectedImage, "it renders a placeholder image")
    }
    
    func testScrollViewDidScrollToBottom() {
        let scrollView = UIScrollView()
        let delegate = MockBookTableViewControllerDelegate()
        systemUnderTest.delegate = delegate
        scrollView.frame.size.height = 10
        scrollView.contentOffset.y = 11
        scrollView.contentSize.height = 21
        
        systemUnderTest.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(delegate.didScrollToBottomWasCalled, true, "it triggers the delegate when you scroll to the bottom")
    }
    
    func testScrollViewDidScrollNotAllTheWayToBottom() {
        let scrollView = UIScrollView()
        let delegate = MockBookTableViewControllerDelegate()
        systemUnderTest.delegate = delegate
        scrollView.frame.size.height = 10
        scrollView.contentOffset.y = 0
        scrollView.contentSize.height = 11
        
        systemUnderTest.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(delegate.didScrollToBottomWasCalled, false, "it does not trigger the delegate when you scroll not all the way to the bottom")
    }
    
    class MockBookTableViewControllerDelegate: SearchResultsViewControllerDelegate {
        
        var didScrollToBottomWasCalled = false
        
        func didScrollToBottom() {
            didScrollToBottomWasCalled = true
        }
    }
    
}


