//
//  Extentions.swift
//  Keddr
//
//  Created by macbook on 03.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String, postUrl: URL) {
        imageUrlString = urlString
        if let url = URL(string: urlString){
            image = #imageLiteral(resourceName: "asus")
            
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                self.image = imageFromCache
                return
            }
            let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(postUrl.lastPathComponent).appendingPathComponent(url.lastPathComponent)
            if FileManager.default.fileExists(atPath: path!.path){
                let image = UIImage(contentsOfFile: path!.path)
                self.image = image
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                }
            }).resume()
        }
    }
}


