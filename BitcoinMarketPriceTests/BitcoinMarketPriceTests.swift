//
//  BitcoinMarketPriceTests.swift
//  BitcoinMarketPriceTests
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import XCTest
@testable import BitcoinMarketPrice

class BitcoinMarketPriceTests: XCTestCase {
    
    // TODO: - Continue Tests
    var validMarketPriceViewModel: MarketPriceViewModel!

    override func setUp() {
        super.setUp()
        
        validMarketPriceViewModel = MarketPriceViewModel(timespan: .lastTwoDays)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
