//
//  NowPlayingViewController.swift
//  MovieAppForMS
//
//  Created by Renjit Peter on 8/30/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import UIKit

class NowPlayingViewController: UICollectionViewController {

    //MARK: - properties
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    fileprivate var viewModel:NowPlayingViewModel!
    fileprivate let itemsPerRow: CGFloat = 2
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("NowPlayingViewController : viewdid Load")
        
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //initialize the viewModel passing it a closure to call when the viewModel has new data
        //in this case, we pass in the view controller's reloadCollectionViewData method
        viewModel = NowPlayingViewModel(reloadCollectionViewCallback: reloadCollectionViewData)
        self.navigationItem.title = "Now Playing Movies"
        
    }
    
    //method is called by the viewModel when it has new data
    func reloadCollectionViewData(success:Bool, error:String){
        if success {
            self.collectionView?.reloadData()
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

//Extension for handling Collection view Data source
extension NowPlayingViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.setUpCollectionViewCell(indexPath: indexPath, collectionView : collectionView)
        
    }
    
    
}

//Extension for setting collection view layout
extension NowPlayingViewController : UICollectionViewDelegateFlowLayout {

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
extension NowPlayingViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.setSelectedCellIndexPath(indexPath: indexPath)
        
        if(viewModel.isSelectedMovieAColletion){
            print("reload page with collection details")
        }else {
            performSegue(withIdentifier: "movieDetailsVC", sender: self)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
        // return false to prevent the sague from story board getting fired before collection didSelectItemAt indexpath is called
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "movieDetailsVC"{
            
            let movieDetailsVC = segue.destination as! MovieDetailsViewController
            
            movieDetailsVC.viewModel = viewModel.getNextViewControllerViewModel()
            
        }
    }
    
    
}
