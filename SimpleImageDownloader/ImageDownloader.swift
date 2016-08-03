//
//  ImageDownloader.swift
//  SimpleImageDownloader
//
//  Created by Bogdan Melnik on 7/6/16.
//  Copyright © 2016 Yohoho. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    var cache: NSCache
    
    var delegate: ImageDownloading?
    
    init(cache: NSCache) {
        self.cache = cache
    }
    
    func downloadImage(URL URL: NSURL) {
        
        if delegate == nil {
            print("There is no assigned delegate!")
            return
        }
        
        if downloadImageFromCache(URL: URL, cache: cache) == nil {
            if let image = downloadImageFromURL(URL: URL,cache: cache) {
                uploadImageToCache(image: image, URL: URL, cache: cache)
            }
        }
    }
    
    
    private func downloadImageFromCache(URL URL: NSURL, cache: NSCache) -> UIImage? {
        
        let key = URL.hash
        
        let image:UIImage? = cache.objectForKey(key) as? UIImage
        
        if image == nil {
            print("There is no current image in cache!")
            return nil
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate?.loaderDidLoadImage(image!)
            
        })
        
        print("Image has been downloaded from cache!")
        return image!
        
    }
    
    private func downloadImageFromURL(URL URL: NSURL, cache: NSCache) -> UIImage? {
        
        let data: NSData? = NSData(contentsOfURL: URL)
        
        if data == nil {
            delegate?.loaderDidFailImageDownloading("Image download failed! Can not get data from URL!")
            return nil
        }
        
        let image: UIImage? = UIImage(data: data!)
        
        if image == nil {
            delegate?.loaderDidFailImageDownloading("Image download failed! Can not get image from data!")
            return nil
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate?.loaderDidLoadImage(image!)
            
        })
        
        print("Image has been downloaded from URL!")
        return image!
    }
    
    private func uploadImageToCache(image image: UIImage, URL: NSURL, cache: NSCache) {
        
        let key = URL.hash
        
        if cache.objectForKey(key) != nil {
            print("Image in cache alredy exist!")
            return
        }
        
        print("Image has been added to cache!")
        cache.setObject(image, forKey: key)
        // Cannot track failure =(
    }
 }
