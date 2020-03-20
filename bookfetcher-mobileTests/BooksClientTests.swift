//
//  BooksClientTests.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/19/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import XCTest
@testable import bookfetcher_mobile

class GoogleBooksClientTest: XCTestCase {

    var systemUnderTest: GoogleBooksClient!
    var mockNetworkingSession: MockNetworkingSession!

    override func setUp() {
        super.setUp()
        mockNetworkingSession = MockNetworkingSession()
        systemUnderTest = GoogleBooksClient(networkingSession: mockNetworkingSession)
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }
    
    func testSearchReturnsResultsFromTheNetwork() {
        // arrange
        let expectedResults = BookResponse(items: [.mock()])
        let encoder = JSONEncoder()
        let data = try! encoder.encode(expectedResults)
        mockNetworkingSession.data = data
        let expect = expectation(description: "wait for completion")
        
        // act
        systemUnderTest.search(query: "test query") { (result: Result<[Book], Error>) in
            let actualResults = try! result.get()
            
            // assert
            XCTAssertEqual(actualResults, expectedResults.items, "it returns a decoded BookResponse when it gets back valid data")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1.0)
    }
    
    func testSearchReturnsEmptyArrayIfResponseItemsIsNil() {
          // arrange
          let expectedResults = BookResponse(items: nil)
          let encoder = JSONEncoder()
          let data = try! encoder.encode(expectedResults)
          mockNetworkingSession.data = data
          let expect = expectation(description: "wait for completion")
          
          // act
          systemUnderTest.search(query: "test query") { (result: Result<[Book], Error>) in
              let actualResults = try! result.get()
              
              // assert
              XCTAssertEqual(actualResults, [], "it returns an empty array when query returns no items")
              expect.fulfill()
          }
          wait(for: [expect], timeout: 1.0)
      }
    
    
    func testSearchReturnsErrorIfNetworkingError() {
        // arrange
        let mockError = MockError()
        mockNetworkingSession.error = mockError
        let expect = expectation(description: "wait for completion")
        
        // act
        systemUnderTest.search(query: "test query") { (result: Result<[Book], Error>) in
            // assert
            switch result {
            case .success: XCTFail()
            case let .failure(error):
                // if the cast fails, error will be nil, and if it succeeds, it will be a MockError
                XCTAssertEqual(error as? MockError, mockError, "it returns the error")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1.0)
    }
    
    func testSearchReturnsErrorIfDecodingError() {
        // arrange
        let data = Data()
        mockNetworkingSession.data = data
        let expect = expectation(description: "wait for completion")
        
        // act
        systemUnderTest.search(query: "test query") { (result: Result<[Book], Error>) in
            // assert
            switch result {
            case .success: XCTFail()
            case let .failure(error):
                // if the cast fails, error will be nil, and if it succeeds, it will be a DecodingError
                XCTAssertNotNil(error as? DecodingError, "it returns a decoding error for invalid data")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1.0)
    }
    
    func testSearchReturnsErrorIfNoData() {
        // arrange
        mockNetworkingSession.data = nil
        let expect = expectation(description: "wait for completion")
        
        // act
        systemUnderTest.search(query: "test query") { (result: Result<[Book], Error>) in
            // assert
            switch result {
            case .success: XCTFail()
            case let .failure(error):
                if let error = error as? GoogleBooksClient.GoogleBooksClientError {
                    XCTAssertEqual(error, .noData, "it returns a noData error")
                } else {
                    XCTFail()
                }
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 1.0)
    }
    
    func testSearchCancelsExistingRequests() {
        // arrange
        let task = MockNetworkingDataTask()
        systemUnderTest.dataTask = task
        
        // act
        systemUnderTest.search(query: "test") { _  in }
        
        // assert
        XCTAssertEqual(task.cancelWasCalled, true, "it calls cancel on current data task when search is called again")
    }
    
    func testSearchSetsDataTaskToBeNetworkingDataTask() {
        // act
        systemUnderTest.search(query: "test") { _  in }
        
        // assert
        XCTAssertTrue(systemUnderTest.dataTask as? MockNetworkingDataTask === mockNetworkingSession.mockNetworkingDataTask, "it sets data task to be the most recent session data task")
    }
    
    func testSearchCallsResumeOnDataTask() {
        // act
        systemUnderTest.search(query: "test") { _  in }
        
        // assert
        XCTAssertEqual((systemUnderTest.dataTask as? MockNetworkingDataTask)?.resumeWasCalled, true, "it calls resume on dataTask")
    }

}

class MockNetworkingSession: NetworkingSession {
    var wasCalledWithURL: URL?
    var data: Data?
    var error: Error?
    var mockNetworkingDataTask: MockNetworkingDataTask?
    
    func networkingTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingDataTask {
        let response = URLResponse()
        completionHandler(data, response, error)
        mockNetworkingDataTask = MockNetworkingDataTask()
        return mockNetworkingDataTask!
    }
    
}

class MockNetworkingDataTask: NetworkingDataTask {
    var cancelWasCalled = false
    var resumeWasCalled = false
    
    func cancel() {
        cancelWasCalled = true
    }
    
    func resume() {
        resumeWasCalled = true
    }
    
}
