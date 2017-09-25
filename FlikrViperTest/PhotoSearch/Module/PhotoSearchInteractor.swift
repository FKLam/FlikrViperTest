//
//  PhotoSearchInteractor.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoSearchInteratorInput: class {
    func fetchAppPhotosFromDataManager(_ searchTag: String, page: NSInteger)
}

protocol PhotoSearchInteratorOutput: class {
    func providePhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger)
    func serviceError(_ error: NSError)
}

class PhotoSearchInteractor: PhotoSearchInteratorInput {
    
    var presenter: PhotoSearchInteratorOutput!
    var APIDataManager: FlickrPhotoSearchProtocol!
    
    func fetchAppPhotosFromDataManager(_ searchTag: String, page: NSInteger) {
        APIDataManager.fetchPhotosForSearchText(searchText: searchTag, page: page) { (error, totalPages, flickrPhotos) in
            if let photos = flickrPhotos {
                // TODO
                print(photos)
                self.presenter.providePhotos(photos, totalPages: totalPages)
            } else if let error = error {
                print(error)
                // TODO
                self.presenter.serviceError(error)
            }
        }
    }
    
}


