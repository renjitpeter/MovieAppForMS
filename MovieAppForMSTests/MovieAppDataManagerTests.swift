//
//  MovieAppDataManagerTests.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import XCTest
@testable import MovieAppForMS


class MovieAppDataManagerTests: XCTestCase {
    
    fileprivate let dataManager:DataManagerProtocol = DataManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchingNowPlayingMovieList(){
        let expectationForNowPlaying = expectation(description: "Now Playing")
        
        dataManager.getNowPlayingMovies { (responseDictionary, error) in
            
            XCTAssert(error == "", "Now playing returned arror")
            
            XCTAssertNotNil(responseDictionary)
            
            XCTAssertNotNil(responseDictionary!["results"])
            
            expectationForNowPlaying.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) -> Void in
        }
    }
    
}
