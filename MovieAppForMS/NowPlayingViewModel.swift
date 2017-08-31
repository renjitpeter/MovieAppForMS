//
//  NowPlayingViewModel.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class NowPlayingViewModel:NSObject {
    
    //MARK: - Properties
    fileprivate let reuseidentifier = "MovieCell"
    fileprivate let kNumberOfSectionsInCollectionView = 1
    fileprivate var dataManager:DataManagerProtocol?
    fileprivate var selectedCellIndexPath : IndexPath!
    var movieList: [Movie] = []
    
    var reloadCollectionViewCallback : (()->())!
    
    init(reloadCollectionViewCallback : @escaping (()->())) {
        
        super.init()
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        dataManager = DataManager()
        self.fetchNowplayingMovies()
        
        print("NowPlayingViewModel : init ")
    }
    
    init(dataManagerObj:DataManagerProtocol, reloadCollectionViewCallback : @escaping (()->())) {
        
        super.init()
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        dataManager = dataManagerObj
        self.fetchNowplayingMovies()
        
        print("NowPlayingViewModel : init ")
    }
    
    func fetchNowplayingMovies() -> () {
        
        dataManager?.getNowPlayingMovies { (responseDictionary, error) in
            guard let array = responseDictionary!["results"] as? [Any] else {
                print("NowPlayingViewModel : no playing results empty ")
                return
            }
            
            for movieData in array{
                if let movieData = movieData as? responseDictionary,
                    let movieId = movieData["id"] as? Int,
                    let movieName = movieData["title"] as? String {
                    
                    let movie = Movie(id: movieId, title: movieName)
                    
                    let avgVote = movieData["vote_average"] as? Float
                    movie.avgVote = avgVote
                    
                    self.movieList.append(movie)
                    
                    if let imagePath = movieData["poster_path"] as? String {
                        movie.imagePath = imagePath
                    }
                    
                    self.fetchMovieDetails(movieId: movieId)
                }
                
            }
            print("NowPlayingViewModel : calling reload ")
            self.reloadCollectionViewCallback()
        }
    }
    

    
    func fetchMovieDetails(movieId:Int) -> () {
        
        self.dataManager?.getMovieDetails(movieID: movieId, completion: { (responseDictionary, error)  in
            let movieDetails: Movie? = self.movieList.filter({$0.movieId == movieId}).first
            if let collactionDetails = responseDictionary!["belongs_to_collection"] as? responseDictionary{
                movieDetails?.isCollection = true
                movieDetails?.collectionID = collactionDetails["id"] as? Int
            }
            movieDetails?.overView = responseDictionary!["overview"] as? String
            movieDetails?.voteCount = responseDictionary!["vote_count"] as? Int
            
        })
    }
}

//For collection view data source
extension NowPlayingViewModel{
    
    func numberOfItemsInSection(section : Int) -> Int {
        return movieList.count
        
    }
    
    func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInCollectionView
        
    }
    
    func setUpCollectionViewCell(indexPath : IndexPath, collectionView : UICollectionView) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        let movie = movieList[indexPath.row] 
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath as IndexPath) as! MovieViewCell
        
        var rating: String = ""
        if let avgVote = movie.avgVote {
            rating = String(avgVote)
        }
        
        (cell as! MovieViewCell).setMovieData(name: movie.movieName, rating: rating)
        
        if let imagePath = movie.imagePath {
            (cell as! MovieViewCell).posterImage.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: UIImage(named: "MovieIcon.png"))
        }
        
        return cell
    }

}

extension NowPlayingViewModel {
    
    func setSelectedCellIndexPath(indexPath : IndexPath){
        
        selectedCellIndexPath = indexPath
        
    }
    
    func getNextViewControllerViewModel() -> MovieDetailsViewModel {
        
        let movie = movieList[selectedCellIndexPath.row]
        
        let movieDetailsViewModel = MovieDetailsViewModel(selectedMovie: movie)
        
        return movieDetailsViewModel
        
    }
}
