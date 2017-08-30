//
//  DataManagerProtocol.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func getNowPlayingMovies (completion : @escaping (responseDictionary?, String) -> ())
    func getMovieDetails (movieID:Int, completion : @escaping (responseDictionary?, String) -> ())
}
