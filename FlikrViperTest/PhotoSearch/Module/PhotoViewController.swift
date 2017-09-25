//
//  PhotoViewController.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoViewControllerOutput {
    func fetchPhotos(_ searchTag: String, page: NSInteger)
    func gotoPhotoDetailScreen()
    func passDataToNextScreen(_ segue: UIStoryboardSegue)
}

protocol PhotoViewControllerInput {
    func displayFetchedPhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger)
    func displayErrorView(_ errorMessage: String)
    func showWaitingView()
    func hideWaitingView()
    func getTotalPhotosCount() -> NSInteger
}

class PhotoViewController: UIViewController, PhotoViewControllerInput {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var presenter: PhotoViewControllerOutput!
    
    var photos: [FlickrPhotoModel] = []
    var currentPage = 1
    var totalPages = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoSearchAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSearchWith(photoSearchKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = photoSearchKey
    }
    
    // request photo service result from presenter
    func performSearchWith(_ searchText: String) {
        presenter.fetchPhotos(searchText, page: currentPage)
    }
    
    // presenter return us with photo results
    func displayFetchedPhotos(_ photos: [FlickrPhotoModel], totalPages: NSInteger) {
        self.photos.append(contentsOf: photos)
        self.totalPages = totalPages
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    // show error
    func displayErrorView(_ errorMessage: String) {
        let refreshAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: okKey, style: .default, handler: { (action) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK:- activityView
    func showWaitingView() {
        let alert = UIAlertController(title: nil, message: waitingKey, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func hideWaitingView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTotalPhotosCount() -> NSInteger {
        return self.photos.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.passDataToNextScreen(segue)
    }
}

// MARK:- UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Photo cell + Loading cell
        if currentPage < totalPages {
            return photos.count + 1
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < photos.count {
            return photoItemCell(collectionView, cellForItemAt: indexPath)
        } else {
            currentPage += 1
            performSearchWith(photoSearchKey)
            return loadingCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func photoItemCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.defaultReuseIdentifier, for: indexPath) as! PhotoItemCell
        let flickrPhoto = self.photos[indexPath.row]
        cell.photoImage.alpha = 0
        cell.photoImage.sd_setImage(with: flickrPhoto.photoUrl as URL) { (image, error, cache, url) in
            cell.photoImage.image = image
            UIView.animate(withDuration: 0.2, animations: { 
                cell.photoImage.alpha = 1.0
            })
        }
        return cell
    }
    
    func loadingCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLoadingCell.defaultReuseIdentifier, for: indexPath) as! PhotoLoadingCell
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
        self.presenter.gotoPhotoDetailScreen()
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize: CGSize
        let length = (UIScreen.main.bounds.width) / 3.0 - 1
        
        if indexPath.row < photos.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: photoCollectionView.bounds.width, height: 50.0)
        }
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}


