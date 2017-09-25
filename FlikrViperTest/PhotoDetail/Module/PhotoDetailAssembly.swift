//
//  PhotoDetailAssembly.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

class PhotoDetailAssembly {
    
    static let sharedInstance = PhotoDetailAssembly()
    
    func configure(_ viewController: PhotoDetailViewController) {
        let APIDataManager: FlickrPhotoLoadImageProtocol = FlickrDataManager()
        let interactor = PhotoDetailInteractor()
        let presenter = PhotoDetailPresenter()
        viewController.presneter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        
        interactor.imageDataManager = APIDataManager
        interactor.presenter = presenter
    }
}
