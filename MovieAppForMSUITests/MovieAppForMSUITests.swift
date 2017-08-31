//
//  MovieAppForMSUITests.swift
//  MovieAppForMSUITests
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import XCTest

class MovieAppForMSUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAppLaunchedCorrectly() {
        let app = XCUIApplication()
        let titleLabel = app.staticTexts["Now Playing Movies"]
        XCTAssertEqual(titleLabel.exists, true)
        
    }
    
    func testAppNavigationToDetails() {
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
        }
        if app.navigationBars["MovieAppForMS.MovieDetailsView"].exists {
            let trackInfoLabel = app.staticTexts["Votes :"]
            XCTAssertEqual(trackInfoLabel.exists, true)
        }
        
        let titleLabel = app.staticTexts["Now Playing Movies"]
        XCTAssertEqual(titleLabel.exists, false)
    }
    
    func testAppNavigationBackFromDetail() {
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
        }
        
        if app.navigationBars["MovieAppForMS.MovieDetailsView"].exists {
            let nowPlayingMoviesButton = app.navigationBars["MovieAppForMS.MovieDetailsView"].buttons["Now Playing Movies"]
            nowPlayingMoviesButton.tap()
        }
        else {
            let nowPlayingMoviesButton = app.navigationBars["MovieAppForMS.CollectionView"].buttons["Now Playing Movies"]
            nowPlayingMoviesButton.tap()
        }
        
        let trackInfoLabel = app.staticTexts["Votes :"]
        XCTAssertEqual(trackInfoLabel.exists, false)
        
        let titleLabel = app.staticTexts["Now Playing Movies"]
        XCTAssertEqual(titleLabel.exists, true)
    }
    
    
}
