//
//  Post+CreateSavedPost.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import CoreData

extension Post {
    func createSavedPost(with context: NSManagedObjectContext, feedElements: [FeedElement]) {
        guard let postUrl = self.url, let thumbnailImageUrl = self.thumbnailImageUrl else { return }
        var feed = [SavedFeedElement]()
        for (position, feedElement) in feedElements.enumerated() {
            let element = feedElement.findOrCreateSavedFeedElement(with: context, position: position)
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
        savedPost.date = self.date! as NSDate
        savedPost.savedFeedElements = NSSet(array: feed)
    }
}
