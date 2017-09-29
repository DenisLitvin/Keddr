//
//  FetchProfileInfo.swift
//  Keddr
//
//  Created by macbook on 27.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension Api {
    static func fetchProfileInfo(with urlString: String, complition: @escaping ([Post]?, Profile?, ApiError?) -> () ){
        guard let url = URL(string: urlString) else {
            complition(nil, nil, ApiErrorConstructor.genericError)
            return
        }
        AuthClient.checkAndValidateUser { (error) in
            if let error = error {
                complition(nil, nil, error)
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    complition(nil, nil, ApiErrorConstructor.genericError)
                }
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode {
                    guard let html = HTML(html: data, encoding: .utf8) else { return }
                    //user
                    let profile = Profile(html: html)
                    //posts
                    var posts = [Post]()
                    for postNode in html.css("#fullcolumn > div"){
                        let post = Post()
                        if let thumbnailNode = postNode.at_css("div > div.thumbnailarea.alignleft > a"),
                            let url = thumbnailNode["href"]{
                            post.url = URL(string: url.encodedCharacters())
                            if let imageNode = thumbnailNode.at_css("img"), let imageUrlString = imageNode["src"]{
                                post.thumbnailImageUrlString = imageUrlString.encodedCharacters()
                            }
                        }
                        if let titleNode = postNode.at_css("div > div.fullcontent > h2 > a"){
                            post.title = titleNode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        if let descriptionNode = postNode.at_css("div > div.fullcontent > p"){
                            post.description = descriptionNode.text
                        }
                        if let dateNode = postNode.at_css("div > div.fullcontent > span"), let text = dateNode.text{
                            let components = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
                            let dateString = components[0]
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            post.date = dateFormatter.date(from: dateString)
                        }
                        posts.append(post)
                    }
                    DispatchQueue.main.async {
                        complition(posts, profile, nil)
                    }
                }
                }.resume()
        }
    }
}

















