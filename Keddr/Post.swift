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
    var thumbnailImageUrlString: String?
    var date: Date?
    var authorName: String = ""
    var commentCount: String?
    var description: String?
    var categories: [String]?
    var postAuthorUrlString: String?
    
    init() {}
    init?(savedPost: SavedPost) {
        guard let url = savedPost.urlString,
            let thumbnailUrl = savedPost.thumbnailImageUrlString,
            let title = savedPost.title,
            let date = savedPost.date,
            let author = savedPost.authorName,
            let commentCount = savedPost.commentCount,
            let description = savedPost.postDescription,
            let category = savedPost.category,
            let postAuthorUrlString = savedPost.postAuthorUrlString else { return nil }
        self.url = URL(string: url)
        self.title = title
        self.thumbnailImageUrlString = thumbnailUrl
        self.date = date
        self.authorName = author
        self.categories = [category]
        self.description = description
        self.commentCount = commentCount
        self.postAuthorUrlString = postAuthorUrlString
    }
    init?(xml: XMLElement){
        if let urlNode = xml.at_css("div > h2 > a"), let urlString = urlNode["href"], let url = URL(string: urlString.percentEncoded()) {
            self.url = url
        }
        guard let urlString = url?.absoluteString, urlString.contains("keddr") else { return nil }
        self.categories = [String]()
        for category in xml.css("div.categories a"){
            let category = category.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.categories?.append(category.uppercased())
        }
        if let descriptionNode = xml.at_css("div > p"), let text = descriptionNode.text{
            self.description = text
        }
        if let dateNode = xml.at_css("span[class^='date']"), let text = dateNode.text{
            let components = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            let dateString = components[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.date = dateFormatter.date(from: dateString)
        }
        if let thumbnailNode = xml.at_css("div > div.thumbnailarea > a > img"){
            if let url = thumbnailNode["data-original"]{
                self.thumbnailImageUrlString = url.percentEncoded()
            }else if let url = thumbnailNode["src"]{
                self.thumbnailImageUrlString = url.percentEncoded()
            }
        }
        if let titleNode = xml.at_css("div > h2 > a"), let title = titleNode.text{
            self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let authorNode = xml.at_css("div > span > noindex > a"), let authorName = authorNode.text {
            self.authorName = authorName
            self.postAuthorUrlString = authorNode["href"]
        }
        self.commentCount = "0"
        if let commentsNode = xml.at_css("div > span > a"), let comments = commentsNode.text{
            self.commentCount = comments
        }
    }
}


