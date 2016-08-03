//
//  ViewController.swift
//  SimpleImageDownloader
//
//  Created by Bogdan Melnik on 7/6/16.
//  Copyright © 2016 Yohoho. All rights reserved.
//

import UIKit

enum ImageStatus: Int{
    case Unavalible
    case Avaliable
}

protocol ImageDownloading {
    func loaderDidLoadImage(image: UIImage)
    func loaderDidFailImageDownloading(errorMessage: String)
}

class ViewController: UIViewController, ImageDownloading {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageStatus = ImageStatus.Unavalible
    
    var cache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateButtonPressed(sender: AnyObject) {
        
        self.activityIndicator.startAnimating()
        let loader = ImageDownloader(cache: cache)
        loader.delegate = self
        dispatch_async(dispatch_get_main_queue(), {
            loader.downloadImage(URL: NSURL.init(string: "http://www.wallpapersforiphone6plus.com/wp-content/uploads/3D/Gray%203D%20for%20iphone%206%20plus%20wallpapers.jpg")!)
        })
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        self.cache.removeAllObjects()
        print("Cache cleaning successfull!")
        self.image.image = UIImage(named: "NoImage")
        self.imageStatus = .Unavalible
        print("Image cleaning successfull!")
        self.activityIndicator.stopAnimating()
    }
    
    func loaderDidLoadImage(image: UIImage) {
        print("Image downloading successfull!")
        self.image.image = image
        imageStatus = .Avaliable
        self.activityIndicator.stopAnimating()

    }
    
    func loaderDidFailImageDownloading(errorMessage: String) {
        print(errorMessage)
        image.image = UIImage(named: "NoImage.png")
        imageStatus = .Unavalible
            self.activityIndicator.stopAnimating()
    }
    
}

