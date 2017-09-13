//
//  FeedElement+findOrCreateFeedElement.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import CoreData
extension FeedElement {
    
    func findOrCreateSavedFeedElement(with context: NSManagedObjectContext, position: Int) -> SavedFeedElement {
        let feedRequest: NSFetchRequest<SavedFeedElement> = SavedFeedElement.fetchRequest()
        feedRequest.predicate = NSPredicate(format: "content = %@", self.content)
        do{
            let result = try context.fetch(feedRequest)
            if result.count > 0 {
                precondition(result.count == 1, "SavedFeedElement - Database inconsistency")
                return result.first!
            }
        } catch {
            print(error)
        }
        let feedElement = SavedFeedElement(context: context)
        feedElement.position = Int16(position)
        feedElement.type = self.type.rawValue
        feedElement.content = self.content
        return feedElement
    }
}
