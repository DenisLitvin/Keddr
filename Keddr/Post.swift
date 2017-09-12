//
//  Post.swift
//  Keddr
//
//  Created by macbook on 22.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import Kanna

class Post {
    
    var url: URL?
    
    var title: String?
    var thumbnailImageUrl: String?
    var date: String?
    var authorName: String = ""
    var commentCount: String?
    var description: String?
    var categories: [String]?
    
    init?(savedPost: SavedPost) {
        guard let url = savedPost.url,
            let thumbnailUrl = savedPost.thumbnailImageUrl,
            let title = savedPost.title,
            let date = savedPost.date,
            let author = savedPost.authorName,
            let commentCount = savedPost.commentCount,
            let description = savedPost.postDescription,
            let category = savedPost.category else { return }
        self.url = URL(string: url)
        self.title = title
        self.thumbnailImageUrl = thumbnailUrl
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.date = dateFormatter.string(from: date as Date)
        self.authorName = author
        self.categories = [category]
        self.description = description
        self.commentCount = commentCount
    }
    init?(xml: XMLElement){
        //getting info for each post
        self.categories = [String]()
        for category in xml.css("div[class^='categories']"){
            let category = category.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.categories?.append(category)
        }
        if let urlNode = xml.at_css("div > h2 > a"), let urlString = urlNode["href"], let url = URL(string: urlString.encodedCharacters()) {
            self.url = url
        }
        if let description = xml.at_css("div > p"), let text = description.text{
            self.description = text
        }
        if let dateNode = xml.at_css("span[class^='date']"), let text = dateNode.text{
            let components = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            let date = components[0].replacingOccurrences(of: "/", with: ".")
            self.date = date
        }
        if let thumbnailUrl = xml.at_css("div > div.thumbnailarea > a > img"){
            if let url = thumbnailUrl["data-original"]{
                self.thumbnailImageUrl = url.encodedCharacters()
            }else if let url = thumbnailUrl["src"]{
                self.thumbnailImageUrl = url.encodedCharacters()
            }
        }
        if let titleNode = xml.at_css("div > h2 > a"), let title = titleNode.text{
            self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let author = xml.at_css("div > span > noindex > a"), let authorName = author.text {
            self.authorName = authorName
        }
        self.commentCount = "0"
        if let commentsNode = xml.at_css("div > span > a"), let comments = commentsNode.text{
            self.commentCount = comments
        }
        guard let urlString = url?.absoluteString else { return nil }
        guard urlString.contains("keddr") else { return nil }
    }
}


import CoreData

let fileManager = FileManager.default

func deleteImages(for postUrl: URL){
    let directoryUrl = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(postUrl.lastPathComponent)
    if fileManager.fileExists(atPath: directoryUrl!.path){
        try? fileManager.removeItem(at: directoryUrl!)
    }
}
func saveImage(with imageUrlString: String, postUrl: URL){
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
        } else { print("exists") }
    } catch {
        //handle the error
    }
}
extension Post {
    func createPost( with context: NSManagedObjectContext, feedElements: [FeedElement]) {
        guard let postUrl = self.url, let thumbnailImageUrl = self.thumbnailImageUrl else { return }
        var feed = [SavedFeedElement]()
        for feedElement in feedElements {
            let element = feedElement.findOrCreateFeedElement(with: context)
            if feedElement.type == .image || feedElement.type == .fotorama {
                let imageUrls = feedElement.content.components(separatedBy: ",")
                for imageUrl in imageUrls {
                    saveImage(with: imageUrl, postUrl: postUrl)
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
        saveImage(with: thumbnailImageUrl, postUrl: postUrl)
        savedPost.commentCount = self.commentCount
        savedPost.authorName = self.authorName
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatted.date(from: self.date!)! as NSDate
        savedPost.date = formattedDate
        savedPost.savedFeedElements = NSSet(array: feed)
    }
    func findPost(with context: NSManagedObjectContext) -> SavedPost? {
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
            print(error)
        }
        return nil
    }
    func findFeed(with context: NSManagedObjectContext, for post: SavedPost) -> [SavedFeedElement]{
        if let posts = post.savedFeedElements{
            let postArray = Array(posts) as! [SavedFeedElement]
            let sortedArray = postArray.sorted { $0.content! > $1.content! }
            return sortedArray
        }
        return []
    }
}


