//
//  PhotoDetailPresenter.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoDetailPresenterInput: PhotoDetailInteractorOutput, PhotoDetailViewControllerOutput {
    
}

class PhotoDetailPresenter: PhotoDetailPresenterInput {
    
    var view: PhotoDetailViewControllerInput!
    var interactor: PhotoDetailInteractorInput!
    
    // Passing data from PhotoSearch Module Router
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel) {
        self.interactor.configurePhotoModel(photoModel)
    }
    
    func loadLargePhotoImage() {
        self.interactor.loadUIImageFromUrl()
    }
    
    // result comes from interactor
    func sendLoadedPhotoImage(_ image: UIImage) {
        self.view.addLargeLoadedPhoto(image)
    }
    
    func getPhotoImageTitle() {
        let imageTitle = self.interactor.getPhotoImageTitle()
        self.view.addPhotoImageTitle(imageTitle)
    }
}
