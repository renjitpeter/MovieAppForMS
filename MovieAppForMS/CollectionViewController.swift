//
//  CollectionViewController.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/31/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var viewModel:CollectionViewModel!
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view.
        
        viewModel.fetchCollectionDetails(imageView:self.posterImageView) { (success, error, collection) in
            if success {
                self.reloadCollectionViewData(collection: collection!)
            } else {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //method is called by the viewModel when it has new data
    func reloadCollectionViewData(collection:Collection){
        self.movieCollectionView?.reloadData()
        self.movieTitle.text = collection.collectionName
        self.movieDescription.text = collection.overView
        self.posterImageView.image = collection.posterImage
    }

}

//Extension for handling Collection view Data source
extension CollectionViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.setUpCollectionViewCell(indexPath: indexPath, collectionView : collectionView)
        
    }
    
    
}


//Extension for setting collection view layout
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem+120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//Extension for handling navigation to detail view
extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.setSelectedCellIndexPath(indexPath: indexPath)
        
        performSegue(withIdentifier: "collectionDetail", sender: self)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
        // return false to prevent the sague from story board getting fired before collection didSelectItemAt indexpath is called
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "collectionDetail"{
            
            let movieDetailsVC = segue.destination as! MovieDetailsViewController
            
            movieDetailsVC.viewModel = viewModel.getMovieDetailViewModel()
            
        }
        
    }
    
    
}
