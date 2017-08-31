//
//  Movie.swift
//  SampleMovieApp
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Movie {
    let movieId: Int
    let movieName : String
    var avgVote : Float?
    var imagePath : String?
    var posterImage : UIImage?
    var isCollection : Bool = false
    var collectionID : Int?
    var overView : String?
    var voteCount : Int?
    
    init(id: Int, title: String) {
        self.movieId = id
        self.movieName = title
    }
    
    
}
