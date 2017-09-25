//
//  PhotoSearchPresenter.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoSearchPresenterInput: PhotoViewControllerOutput, PhotoSearchInteratorOutput {
    
}

class PhotoSearchPresenter: PhotoSearchPresenterInput {
    
    var view: PhotoViewControllerInput!
    
    var interactor: PhotoSearchInteratorInput!
    
    var router: PhotoSearchRouterInput!
    
    // Presenter says interactor ViewController needs photos
    func fetchPhotos(_ searchTag: String, page: NSInteger) {
        if view.getTotalPhotosCount() == 0 {
            view.showWaitingView()
        }
        interactor.fetchAppPhotosFromDataManager(searchTag, page: page)
    }
    
    // service return photos and interactor passes all data to presenter which make view display them
    func providePhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger) {
        view.hideWaitingView()
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
    }
    
    // show error message from service
    func serviceError(_ error: NSError) {
        self.view.displayErrorView(defaultErrorMessage)
    }
    
    func gotoPhotoDetailScreen() {
        self.router.navigateToPhotoDetail()
    }
    
    func passDataToNextScreen(_ segue: UIStoryboardSegue) {
        self.router.passDataToNextScreen(segue)
    }
}
