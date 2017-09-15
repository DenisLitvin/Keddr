//
//  FetchComments.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension Api {
    
    static func fetchComments(for post: Post, complition: @escaping([Comment]?)->()) {
        let url = URL(string: "https://keddr.com/2017/09/apple-predstavila-iphone-8-i-iphone-8-plus/")
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            if let data = data, let review = HTML(html: data, encoding: .utf8),
                let container = review.at_css("#decomments-comment-section > div.decomments-comment-list"){
                for xml in container.css("div[class^='comment']"){
                    let comment = Comment(xml: xml)
                }
            }
            DispatchQueue.main.async {
//                complition(resultPosts)
            }
        }).resume()
    }
}












