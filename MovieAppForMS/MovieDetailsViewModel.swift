//
//  MovieDetailsViewModel.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/31/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation

class MovieDetailsViewModel:NSObject {
    var movie:Movie?
    
    init(selectedMovie:Movie) {
        super.init()
        movie = selectedMovie
    }
    
    func getMovieDetails() -> Movie  {
        return movie!
    }
}
