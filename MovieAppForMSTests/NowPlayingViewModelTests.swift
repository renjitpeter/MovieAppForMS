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
        
    }
    
    
}

class DataManagerMock: DataManagerProtocol {
    
    func getNowPlayingMovies (completion : @escaping (responseDictionary?, String) -> ()){
        let file = "NowPlayingDummy.rtf"
        var responseData: Data?
        var errorMessage = ""
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            do {
                let responseString = try String(contentsOf: path, encoding: String.Encoding.utf8)
                responseData = try JSONSerialization.data(withJSONObject: responseString, options: [])
            }
            catch {/* error handling here */}
        }
        
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
}

