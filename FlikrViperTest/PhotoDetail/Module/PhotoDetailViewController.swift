//
//  PhotoDetailViewController.swift
//  FlikrViperTest
//
//  Created by amglfk on 2017/9/24.
//  Copyright © 2017年 amglfk. All rights reserved.
//

import UIKit

protocol PhotoDetailViewControllerInput: class {
    func addLargeLoadedPhoto(_ image: UIImage)
    func addPhotoImageTitle(_ title: String)
}

protocol PhotoDetailViewControllerOutput: class {
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel)
    func loadLargePhotoImage()
    func getPhotoImageTitle()
}

class PhotoDetailViewController: UIViewController, PhotoDetailViewControllerInput {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    var presneter: PhotoDetailViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoDetailAssembly.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ask title and image from presenter
        self.presneter.getPhotoImageTitle()
        self.presneter.loadLargePhotoImage()
        self.view.backgroundColor = UIColor.white
    }
    
    // result come from presenter
    func addLargeLoadedPhoto(_ image: UIImage) {
        self.imageView.image = image
    }
    
    func addPhotoImageTitle(_ title: String) {
        self.imageNameLabel.text = title
    }

}
