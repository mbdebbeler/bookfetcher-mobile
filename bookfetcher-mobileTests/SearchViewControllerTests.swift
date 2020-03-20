//
//  SearchViewControllerTests.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/19/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import XCTest
@testable import bookfetcher_mobile

class SearchViewControllerTests: XCTestCase {
    
    var systemUnderTest: SearchViewController!
    var mockBooksClient: MockBooksClient!
    
    override func setUp() {
        super.setUp()
        mockBooksClient = MockBooksClient()
        systemUnderTest = SearchViewController(booksClient: mockBooksClient)
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }
    
    func testSearchBarSearchButtonWasClicked() {
        // arrange
        let mockSearchBar = UISearchBar()
        let expectedLastQuery = "test query"
        mockSearchBar.text = expectedLastQuery
        let resultsVC = systemUnderTest.searchResultsViewController
        resultsVC.books = [.mock()]
        resultsVC.loadingView.isHidden = true
        resultsVC.noResultsView.isHidden = false
        resultsVC.errorView.isHidden = false
        
        // act
        systemUnderTest.searchBarSearchButtonClicked(mockSearchBar)
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalled, true, "it calls search on the BooksClient")
        XCTAssertEqual(mockBooksClient.searchWasCalledWithQuery, expectedLastQuery, "it calls search with the right query")
        XCTAssertEqual(mockBooksClient.searchWasCalledWithOffset, 0, "it calls search with offset 0")
        XCTAssertEqual(systemUnderTest.lastQuery, expectedLastQuery, "it sets the query to the text from the search bar")
        XCTAssertEqual(systemUnderTest.fetchedAllResults, false, "it sets fetchedAllResults to false")
        XCTAssert(resultsVC.books.isEmpty, "it calls prepareForSearch which clears the books")
        XCTAssert(resultsVC.loadingView.isHidden == false, "it calls prepareForSearch which shows the loading view")
        XCTAssert(resultsVC.noResultsView.isHidden == true, "it calls prepareForSearch which hides the no results view")
        XCTAssert(resultsVC.errorView.isHidden == true, "it calls prepareForSearch which hides the error view")
    }
    
    func testSearchBarCancelButtonClicked() {
        // arrange
        let mockSearchBar = UISearchBar()
        systemUnderTest.lastQuery = "test query"
        systemUnderTest.fetchedAllResults = true
        let resultsVC = systemUnderTest.searchResultsViewController
        resultsVC.books = [.mock()]
        resultsVC.loadingView.isHidden = true
        resultsVC.noResultsView.isHidden = false
        resultsVC.errorView.isHidden = false
          
          // act
        systemUnderTest.searchBarCancelButtonClicked(mockSearchBar)
        
        // assert
        XCTAssertEqual(systemUnderTest.lastQuery, nil, "it clears lastQuery")
        XCTAssertEqual(systemUnderTest.fetchedAllResults, false, "it sets fetchedAllResults to false")
        XCTAssert(resultsVC.books.isEmpty, "it calls prepareForSearch which clears the books")
        XCTAssert(resultsVC.loadingView.isHidden == false, "it calls prepareForSearch which shows the loading view")
        XCTAssert(resultsVC.noResultsView.isHidden == true, "it calls prepareForSearch which hides the no results view")
        XCTAssert(resultsVC.errorView.isHidden == true, "it calls prepareForSearch which hides the error view")
    }
    
    func testSearchWontSearchIfAlreadySearching() {
        // arrange
        systemUnderTest.isSearching = true
        let testQuery = "test query"
        
        // act
        systemUnderTest.search(query: testQuery)
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalled, false, "it returns early and doesn't make a call to the API if it's already searching")
    }
    
    func testSearchWontSearchIfItAlreadyFetchedAllResults() {
        // arrange
        systemUnderTest.fetchedAllResults = true
        let testQuery = "test query"
        
        // act
        systemUnderTest.search(query: testQuery)
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalled, false, "it returns early and doesn't make a call to the API if it has already fetched all results for this query")
    }
    
    func testSearchSetsBooksToTheBooksInResult() {
        // arrange
        systemUnderTest.searchResultsViewController.books = []
        let testQuery = "test query"
        let expectedBooksArray = try! mockBooksClient.result.get()
        
        let expect = expectation(description: "wait for dispatch async")

        // act
        systemUnderTest.search(query: testQuery)
        DispatchQueue.main.async {
            let actualBooksArray = self.systemUnderTest.searchResultsViewController.books
            
            // assert
            XCTAssertEqual(expectedBooksArray, actualBooksArray, "it sets the books based on the result")

            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 1.0)
    }
    
    func testSearchSetsSearchingTrueUntilSearchIsDone() {
        // arrange
        let testQuery = "test query"
        mockBooksClient.shouldDelay = true
        
        // act
        systemUnderTest.search(query: testQuery)
        XCTAssertEqual(systemUnderTest.isSearching, true, "it sets isSearching to true until it completes")
        mockBooksClient.finish()
        
        // assert
        XCTAssertEqual(systemUnderTest.isSearching, false, "it sets isSearching to false once the completion is called")

    }
    
    func testSearchOnlySearchesOnceIfItReceivedMultipleCallsWhileSearching() {
        // arrange
        let testQuery = "test query"
        mockBooksClient.shouldDelay = true
        
        // act
        systemUnderTest.search(query: testQuery)
        systemUnderTest.search(query: testQuery)
        mockBooksClient.finish()
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalledCounter, 1, "it only calls once while still searching")

    }
    
    func testSearchSetsFetchedAllResultsToTrueIfResultIsEmpty() {
        // arrange
        let testQuery = "test query"
        mockBooksClient.result = .success([])
        
        // act
        systemUnderTest.search(query: testQuery)
        
        // assert
        XCTAssertEqual(systemUnderTest.fetchedAllResults, true, "it sets fetchedAllResults to true")
    }
    
    func testDidScrollToBottomCallsSearch() {
        // arrange
        let testQuery = "test query"
        systemUnderTest.lastQuery = testQuery
        
        // act
        systemUnderTest.didScrollToBottom()
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalled, true, "it makes another call to the API to fetch more results when lastQuery is set")

    }
    
    func testDidScrollToBottomDoesNotCallSearchIfNoLastQuery() {
        // arrange
        systemUnderTest.lastQuery = nil
        
        // act
        systemUnderTest.didScrollToBottom()

        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalled, false, "it returns early and does not call search again when there is no lastQuery")
        
    }
    
    func testDidScrollToBottomCallsSearchWithCorrectOffset() {
        // arrange
        let testQuery = "test query"
        systemUnderTest.lastQuery = testQuery
        systemUnderTest.searchResultsViewController.books = [.mock()]
        
        // act
        systemUnderTest.didScrollToBottom()
        
        // assert
        XCTAssertEqual(mockBooksClient.searchWasCalledWithOffset, 1, "it calls search with the correct offset from the prior search")
        
    }

}

class MockBooksClient: BooksClient {
    var searchWasCalled = false
    var searchWasCalledWithQuery: String?
    var searchWasCalledCounter = 0
    var searchWasCalledWithOffset = 0
    var result: Result<[Book], Error> = .success([.mock()])
    var shouldDelay = false
    
    // when we set delayCompletion to true and call search,
    // the test will wait to actually call the real completion until we call finish,
    // thus allowing us to check that while search is working, isSearching is set to true
    var delayCompletion: (() -> Void)?
    
    func search(query: String, offset: Int, completion: @escaping (Result<[Book], Error>) -> Void) {
        self.searchWasCalled = true
        self.searchWasCalledCounter += 1
        self.searchWasCalledWithOffset = offset
        self.searchWasCalledWithQuery = query
        if shouldDelay {
            self.delayCompletion = {
                completion(self.result)
            }
        }
        else {
            completion(result)
        }
    }
    
    func finish() {
        delayCompletion?()
    }
    
}
