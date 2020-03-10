//
//  bookfetcher_mobileTests.swift
//  bookfetcher-mobileTests
//
//  Created by Monica Debbeler on 3/10/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import XCTest
@testable import bookfetcher_mobile

class bookfetcher_mobileTests: XCTestCase {
    
    var systemUnderTest: SearchViewController!
    
    override func setUp() {
        super.setUp()
        systemUnderTest = SearchViewController()
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }

    func testTrueIsTrue() {
        let expected = true
        
        XCTAssertEqual(systemUnderTest.returnTrue(), expected, "The function returns true")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
