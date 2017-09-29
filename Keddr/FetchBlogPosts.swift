//
//  FetchBlogPosts.swift
//  Keddr
//
//  Created by macbook on 29.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import Kanna

extension Api {
    
    static func fetchBlogPosts(for page: Int, complition: @escaping([Post]) -> () ) {
        guard let url = URL(string: "https://keddr.com/category/blogs/page/\(page)/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode {
                guard let html = HTML(html: data, encoding: .utf8) else { return }
                var posts = [Post]()
                for postNode in html.css("div.articlecontainer.nonfeatured.maincontent.full > div.post-box.cat_branded_type_one > div"){
                    let post = Post()
                    if let thumbnailNode = postNode.at_css("div > div.thumbnailarea > a"), let urlString = thumbnailNode["href"], let url = URL(string: urlString.encodedCharacters()){
                        post.url = url
                        if let imageNode = thumbnailNode.at_css("img"), let thumbnailImageUrlString = imageNode["src"]{
                            post.thumbnailImageUrlString = thumbnailImageUrlString.encodedCharacters()
                        }
                    }
                    if let titleNode = postNode.at_css("div > h2 > a"), let text = titleNode.text {
                        post.title = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if let descriptionNode = postNode.at_css("div > p"), let text = descriptionNode.text {
                        post.description = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if let dateNode = postNode.at_css("div > span"), let text = dateNode.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        let dateString = text.components(separatedBy: " ")[0]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        post.date = dateFormatter.date(from: dateString)
                        if let authorNode = dateNode.at_css("noindex > a"), let text = authorNode.text{
                            post.postAuthorUrlString = authorNode["href"]
                            post.authorName = text
                        }
                    }
                    post.commentCount = "0"
                    if let commentNode = postNode.at_css("div > span > a"), let text = commentNode.text{
                        post.commentCount = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    post.categories = ["БЛОГИ"]
                    posts.append(post)
                }
                DispatchQueue.main.async {
                    complition(posts)
                }
            }
        }.resume()
    }
}




















