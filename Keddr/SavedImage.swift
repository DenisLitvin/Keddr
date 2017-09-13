//
//  SavedImage.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class SavedImage{
    static let fileManager = FileManager.default
    
    static func deleteImages(for postUrl: URL){
        DispatchQueue.global().async {
            let directoryUrl = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(postUrl.lastPathComponent)
            if fileManager.fileExists(atPath: directoryUrl!.path){
                try? fileManager.removeItem(at: directoryUrl!)
            }
        }
    }
    static func saveImage(with imageUrlString: String, postUrl: URL){
        DispatchQueue.global().async {
            do{
                let directoryUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(postUrl.lastPathComponent)
                if !fileManager.fileExists(atPath: directoryUrl.path) {
                    try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: false)
                }
                let pathToImage = URL(string: imageUrlString)!.lastPathComponent
                let urlToSave = directoryUrl.appendingPathComponent(pathToImage)
                if !fileManager.fileExists(atPath: urlToSave.path){
                    let data = try Data(contentsOf: URL(string: imageUrlString)!)
                    try data.write(to: urlToSave)
                }
            } catch {
                print("Failed to save image - \(imageUrlString)")
            }
        }
    }
}
