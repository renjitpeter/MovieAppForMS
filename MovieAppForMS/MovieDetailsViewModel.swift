//
//  MovieDetailsViewModel.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/31/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MovieDetailsViewModel:NSObject {
    var movie:Movie?
    
    init(selectedMovie:Movie) {
        super.init()
        movie = selectedMovie
    }
    
    func getMovieDetails() -> Movie  {
        let posterImageView = UIImageView()
        if let imagePath = self.movie?.imagePath {
            posterImageView.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: UIImage(named: "MovieIcon.png"))
        }
        movie?.posterImage = posterImageView.image
        return movie!
    }
}
