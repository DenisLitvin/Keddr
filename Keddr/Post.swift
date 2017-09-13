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
    var date: Date?
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
        self.date = date as Date
        self.authorName = author
        self.categories = [category]
        self.description = description
        self.commentCount = commentCount
    }
    init?(xml: XMLElement){
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
            let dateString = components[0].replacingOccurrences(of: "/", with: ".")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            self.date = dateFormatter.date(from: dateString)
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


