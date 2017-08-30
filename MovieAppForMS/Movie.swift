//
//  Movie.swift
//  SampleMovieApp
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation

class Movie {
    let movieId: Int
    let movieName : String
    var avgVote : Float?
    var imagePath : String?
    var posterImage : Data?
    var isCollection : Bool?
    var collectionID : Int?
    var overView : String?
    var voteCount : Int?
    
    init(id: Int, title: String) {
        self.movieId = id
        self.movieName = title
    }
    
    
}
