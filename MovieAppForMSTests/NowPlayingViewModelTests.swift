//
//  NowPlayingViewModelTests.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import XCTest
@testable import MovieAppForMS

class NowPlayingViewModelTests: XCTestCase {
    
    let dataManager:DataManagerProtocol = DataManagerMock()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchNowplayingMovie() {
        
        let expectationForNowPlaying = expectation(description: "waitingForNowPlaying")
        let viewModel:NowPlayingViewModel? = NowPlayingViewModel(dataManagerObj: dataManager) {
            expectationForNowPlaying.fulfill()
        }
                                                                 
        viewModel?.fetchNowplayingMovies()
        
        waitForExpectations(timeout: 1.0) { (_) -> Void in
            XCTAssert((viewModel?.movieList.count)! > 0, "Data not returned correctly")
            
        }
    }
    
    
}

class DataManagerMock: DataManagerProtocol {
    
    func getNowPlayingMovies (completion : @escaping (responseDictionary?, String) -> ()){        
        var errorMessage = ""
        
        let responseData: Data? = readJson(file: "NowPlayingDummy")
        
        var responseDictionary: responseDictionary?
        
        if let responseData = responseData {
            do {
                responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? responseDictionary
            } catch let parseError as NSError {
                errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            }
        }
        
        DispatchQueue.main.async {
            completion(responseDictionary,errorMessage)
        }
    }
    func getMovieDetails (movieID:Int, completion : @escaping (responseDictionary?, String) -> ()){
        
    }
    func fetchImage(url:String, completion: @escaping (_ imageData:Data?, _ errorMessage:String?) -> Void) -> Void{
        
    }
    
    private func readJson(file:String) -> Data?{
        var data:Data?
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file, ofType: "json")!
        data = NSData(contentsOfFile: path) as Data?
            
        return data
    }
}

