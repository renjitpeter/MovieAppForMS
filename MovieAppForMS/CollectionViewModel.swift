//
//  CollectionViewModel.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/31/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CollectionViewModel:NSObject {
    
    fileprivate var dataManager:DataManagerProtocol?
    fileprivate let kNumberOfSectionsInCollectionView = 1
    fileprivate var selectedCellIndexPath : IndexPath!
    fileprivate let reuseidentifier = "MovieCell"
    fileprivate var collectionId:Int?
    var movieList: [Movie] = []
    var collection:Collection?
    
    init(collectionId:Int) {
        super.init()
        dataManager = DataManager()
        self.collectionId = collectionId
//        self.fetchCollectionDetails(collectionId: collectionId)
    }
    
    func fetchCollectionDetails(imageView:UIImageView, callback: @escaping (Bool,String,Collection?)->()) -> () {
        
        self.dataManager?.getCollectionDetails(collectionID: self.collectionId!, completion: { (responseDictionary, error)  in
            
            if let responseDictionary = responseDictionary,
                let collectionId = responseDictionary["id"] as? Int,
                let collectionName =  responseDictionary["name"] as? String {
                self.collection = Collection(id: collectionId, title: collectionName)
                if let imagePath = responseDictionary["poster_path"] as? String {
                    self.collection?.imagePath = imagePath
                }
                
                self.collection?.overView = responseDictionary["overview"] as? String
                
                if let imagePath = self.collection?.imagePath {
                    imageView.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: UIImage(named: "MovieIcon.png"))
                }
                self.collection?.posterImage = imageView.image

                
                guard let movieParts = responseDictionary["parts"] as? [Any] else {
                    print("Collection : parts results empty ")
                    callback(false,"Failed to fetch data. Please try later",nil)
                    return
                }
                
                for movieData in movieParts{
                    if let movieData = movieData as? responseDictionary,
                        let movieId = movieData["id"] as? Int,
                        let movieName = movieData["title"] as? String {
                        
                        let movie = Movie(id: movieId, title: movieName)
                        
                        let avgVote = movieData["vote_average"] as? Float
                        movie.avgVote = avgVote
                        
                        if let imagePath = movieData["poster_path"] as? String {
                            movie.imagePath = imagePath
                        }
                        
                        movie.overView = movieData["overview"] as? String
                        movie.voteCount = movieData["vote_count"] as? Int
                        
                        self.movieList.append(movie)
                    }
                    
                }
                
                self.collection?.movieList.append(contentsOf: self.movieList)
                
                callback(true,"",self.collection)
            }
            else {
                callback(false,"Failed to fetch data. Please try later",nil)
            }
        })
    }
}

//For collection view data source
extension CollectionViewModel{
    
    func numberOfItemsInSection(section : Int) -> Int {
        return (self.movieList.count)
        
    }
    
    func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInCollectionView
        
    }
    
    func setUpCollectionViewCell(indexPath : IndexPath, collectionView : UICollectionView) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        let movie = self.movieList[indexPath.row]
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath as IndexPath) as! MovieViewCell
        
        var rating: String = ""
        if let avgVote = movie.avgVote {
            rating = String(avgVote)
        }
        
        (cell as! MovieViewCell).setMovieData(name: (movie.movieName), rating: rating)
        
        if let imagePath = movie.imagePath {
            (cell as! MovieViewCell).posterImage.sd_setImage(with: URL(string: imageBaseURL + imagePath), placeholderImage: UIImage(named: "MovieIcon.png"))
        }
        
        return cell
    }
    
}

//For initialisation and navigation to detail view
extension CollectionViewModel {
    
    func setSelectedCellIndexPath(indexPath : IndexPath){
        
        selectedCellIndexPath = indexPath

    }
    
    func getMovieDetailViewModel() -> MovieDetailsViewModel {
        
        let movie = movieList[selectedCellIndexPath.row]
        let movieDetailsViewModel = MovieDetailsViewModel(selectedMovie: movie)
        
        return movieDetailsViewModel
        
    }

}
