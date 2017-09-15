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
        request.predicate = NSPredicate(format: "url = %@", "\(url)")
        do{
            let result = try context.fetch(request)
            if result.count > 0 {
                precondition(result.count == 1, "SavedPost - Database inconsistency")
                return result.first
            }
        } catch {
            print("Failed to find Saved Post")
        }
        return nil
    }
}
