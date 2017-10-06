//
//  Post+CreateSavedPost.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import CoreData

extension Post {
    func createSavedPost(with context: NSManagedObjectContext, feedElements: [PostElement]) {
        guard let postUrl = self.url, let thumbnailImageUrl = self.thumbnailImageUrlString else { return }
        var feed = [SavedPostElement]()
        for (position, postElement) in feedElements.enumerated() {
            let element = postElement.findOrCreateSavedPostElement(with: context, position: position)
            if postElement.type == .image || postElement.type == .fotorama {
                let imageUrls = postElement.content.components(separatedBy: ",")
                for imageUrl in imageUrls {
                    SavedImage.saveImage(with: imageUrl, postUrl: postUrl)
                }
            }
            feed.append(element)
        }
        let savedPost = SavedPost(context: context)
        savedPost.urlString = postUrl.absoluteString
        savedPost.title = self.title
        savedPost.postDescription = self.description
        savedPost.category = self.categories?.first
        savedPost.thumbnailImageUrlString = self.thumbnailImageUrlString
        SavedImage.saveImage(with: thumbnailImageUrl, postUrl: postUrl)
        savedPost.commentCount = self.commentCount
        savedPost.authorName = self.authorName
        savedPost.date = self.date
        savedPost.savedPostElements = NSOrderedSet(array: feed)
        savedPost.postAuthorUrlString = self.postAuthorUrlString
    }
}
