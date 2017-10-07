//
//  FetchComments.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension ApiManager {
    
    static func fetchComments(for post: Post, complition: @escaping([Comment], String?)->()) {
        URLSession.shared.dataTask(with: post.url!, completionHandler: { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            var comments = [Comment]()
            guard let data = data, let review = HTML(html: data, encoding: .utf8) else { return }
            if let container = review.at_css("#decomments-comment-section > div.decomments-comment-list"){
                for xml in container.css("div[class^='comment']"){
                    if let comment = Comment(xml: xml) {
                        comments.append(comment)
                    }
                }
            }
            var postId: String?
            if let idNode = review.at_css("div.mistape_dialog_block > a:nth-child(1)"), let id = idNode["data-id"]{
                postId = id
            }
            DispatchQueue.main.async {
                complition(comments, postId)
            }
        }).resume()
    }
}












