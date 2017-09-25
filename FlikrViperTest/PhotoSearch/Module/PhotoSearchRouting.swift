//
//  PhotoSearchRouting.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoSearchRouterInput: class {
    func navigateToPhotoDetail()
    func passDataToNextScreen(_ segue: UIStoryboardSegue)
}

class PhotoSearchRouting: PhotoSearchRouterInput {
    
    weak var viewController: PhotoViewController!
    
    // MARK:- Navigation
    func navigateToPhotoDetail() {
        viewController.performSegue(withIdentifier: "ShowDetailVC", sender: nil)
    }
    
    func passDataToNextScreen(_ segue: UIStoryboardSegue) {
        if segue.identifier == "ShowDetailVC" {
            passDataToShowPhotodetailScreen(segue)
        }
    }
    
    // navigate to another module
    func passDataToShowPhotodetailScreen(_ segue: UIStoryboardSegue) {
        if let selectedIndexPath = viewController.photoCollectionView.indexPathsForSelectedItems?.first {
            let selectedPhotoModel = viewController.photos[selectedIndexPath.item]
            let showDetailViewController = segue.destination as! PhotoDetailViewController
            
            showDetailViewController.presneter.saveSelectedPhotoModel(selectedPhotoModel)
        }
    }
}
