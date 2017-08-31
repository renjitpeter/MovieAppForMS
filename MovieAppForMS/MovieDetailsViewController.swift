//
//  MovieDetailsViewController.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/31/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var noOfVotes: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var viewModel:MovieDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie = viewModel.getMovieDetails()
        
        movieTitle.text = movie.movieName
        
        var moviePosterImage: UIImage?
        
        if let posterImage = movie.posterImage {
            moviePosterImage = posterImage
        }
        posterImageView.image = moviePosterImage
        if let avgVote = movie.avgVote {
            movieRating.text = String(avgVote)
        }
        if let voteCount = movie.voteCount {
            noOfVotes.text = String(voteCount)
        }
        if let overView = movie.overView {
            movieDescription.text = overView
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
