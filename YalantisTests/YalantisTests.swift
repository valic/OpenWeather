//
//  YalantisTests.swift
//  YalantisTests
//
//  Created by Valentyn Mialin on 10/13/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import XCTest
import Alamofire

class YalantisTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDailyForecast() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let e = expectation(description: "Alamofire")
        OpenWeatherMap.getDailyForecast(cityID: "703448", cnt: 16) { response in
            switch response {
            case .success(let forecast):
                XCTAssertNotNil(forecast, "Expected non-nil string")
            case .failure(let error):
                XCTAssertNil(error, "Whoops, error \(error.localizedDescription)")
            }
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
