//
//  Post+Find&CreateSavedPost.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//
import CoreData
import Foundation

extension Post {
    
    func findSavedPost(with context: NSManagedObjectContext) -> SavedPost? {
        guard let url = self.url else { return nil}
        let request: NSFetchRequest<SavedPost> = SavedPost.fetchRequest()
        request.predicate = NSPredicate(format: "urlString = %@", "\(url)")
        do{
            let result = try context.fetch(request)
            if result.count > 0 {
                let firstPost = result.first
                //delete the rest if more than 1
                result.forEach({ (post) in
                    if post != firstPost {
                        context.delete(post)
                    }
                })
                return firstPost
            }
        } catch {
            print("Failed to find Saved Post")
        }
        return nil
    }
}
