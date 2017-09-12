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
    func createSavedPost(with context: NSManagedObjectContext, feedElements: [FeedElement]) {
        guard let postUrl = self.url, let thumbnailImageUrl = self.thumbnailImageUrl else { return }
        var feed = [SavedFeedElement]()
        for feedElement in feedElements {
            let element = feedElement.findOrCreateFeedElement(with: context)
            if feedElement.type == .image || feedElement.type == .fotorama {
                let imageUrls = feedElement.content.components(separatedBy: ",")
                for imageUrl in imageUrls {
                    SavedImage.saveImage(with: imageUrl, postUrl: postUrl)
                }
            }
            feed.append(element)
        }
        let savedPost = SavedPost(context: context)
        savedPost.url = postUrl.absoluteString
        savedPost.title = self.title
        savedPost.postDescription = self.description
        savedPost.category = self.categories?.first
        savedPost.thumbnailImageUrl = self.thumbnailImageUrl
        SavedImage.saveImage(with: thumbnailImageUrl, postUrl: postUrl)
        savedPost.commentCount = self.commentCount
        savedPost.authorName = self.authorName
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatted.date(from: self.date!)! as NSDate
        savedPost.date = formattedDate
        savedPost.savedFeedElements = NSSet(array: feed)
    }
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
