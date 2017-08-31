//
//  MovieViewCell.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    func setMovieData(name: String, rating: String){
        movieName.text = name
        movieRating.text = rating
        
    }
}
