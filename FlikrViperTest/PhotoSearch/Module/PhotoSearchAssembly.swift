//
//  PhotoSearchAssembly.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

class PhotoSearchAssembly {
    
    static let sharedInstance = PhotoSearchAssembly()
    
    func configure(_ viewController: PhotoViewController) {
        let APIDataManager = FlickrDataManager()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        let router = PhotoSearchRouting()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.APIDataManager = APIDataManager
        router.viewController = viewController
    }
}
