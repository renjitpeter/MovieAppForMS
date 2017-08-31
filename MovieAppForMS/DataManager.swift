//
//  DataManager.swift
//  SampleMovieApp
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation

let apiKey = "0d40220c33e7d7852087b0e4abfec55c"
let baseURL = "https://api.themoviedb.org/3"
let imageBaseURL = "https://image.tmdb.org/t/p/w185"
let nowPlayingURL = "/movie/now_playing"
let movieURL = "/movie/"

typealias responseDictionary = [String: Any]

class DataManager: NSObject, DataManagerProtocol {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""


    // geth the list of all movies playing now
    func getNowPlayingMovies (completion : @escaping (responseDictionary?, String) -> ()) {
        
        print("Datamanger : getNowPlayingMovies")
        guard let url = generateURL(nowPlayingURL) else{
            print("Datamanger : getNowPlayingMovies url failed")
            return
        }
        
        self.fetchData(url: url, completion: completion)
        
    }
    
    //Service for fetching movie details for provided movie id
    func getMovieDetails (movieID:Int, completion : @escaping (responseDictionary?, String) -> ()) {
        
        let movieURLString = movieURL+String(movieID)
        
        guard let url = generateURL(movieURLString) else{
            print("Datamanger : getMovieDetails url failed")
            return
        }
        
        self.fetchData(url: url, completion: completion)
    }
    
    //Fetch the data and send the response data for processing based on the URL provided
    fileprivate func fetchData(url:URL, completion : @escaping (responseDictionary?, String) -> ()) {
        var responseData: responseDictionary?
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                self.errorMessage = "service failed due to error :" + error.localizedDescription
                print("Datamanger : feth data error" + self.errorMessage)
                
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                responseData = self.processResponse(data)
            }
            
            DispatchQueue.main.async {
                completion(responseData,self.errorMessage)
            }
        })
        
        dataTask?.resume()
    }
    
    //Generate URL required to fire APIs
    fileprivate func generateURL(_ forService:String) -> URL? {
        
        let urlString = baseURL+forService+"?api_key="+apiKey
        
        guard let url = URL(string:urlString) else {
            return nil
        }
        return url
    }

    // Process the response data and convert to Dictionary
    fileprivate func processResponse(_ data:Data) -> responseDictionary? {
        var responseDictionary: responseDictionary?
        
        do {
            responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? responseDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
        
        return responseDictionary
    }
}
