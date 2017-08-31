//
//  Collection.swift
//  MovieAppForMS
//
//  Created by Peter, Renjit (TCS) on 31/08/17.
//  Copyright © 2017 Renjit Peter. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Collection {
    let collectionId: Int
    let collectionName : String
    var imagePath : String?
    var posterImage : UIImage?
    var overView : String?
    var movieList : [Movie] = []
    
    init(id: Int, title: String) {
        self.collectionId = id
        self.collectionName = title
    }
    
    
}
