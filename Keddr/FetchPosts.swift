//
//  FetchHTML.swift
//  Keddr
//
//  Created by macbook on 22.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna


class Api: NSObject{
    static func fetchPosts(for category: PostCategory, page: Int, complition: @escaping ([Post]) -> () ) {
        
    }
    static func fetchPosts(for page: Int, complition: @escaping ([Post]) -> () ) {
        var resultPosts = [Post]()
        if let url = URL(string: "https://keddr.com/lenta/page/\(page)/"){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                if let data = data, let review = HTML(html: data, encoding: .utf8){
                    for xml in review.css("body > div.sitecontainer.container > div.mainbody > div > div:nth-child(3) > div.articlecontainer.nonfeatured.maincontent > div.post-box > div"){
                        let post = Post(xml: xml)
                        if let post = post {
                            resultPosts.append(post)
                        }
                    }
                }
                DispatchQueue.main.async {
                    complition(resultPosts)
                }
            }).resume()
        }
    }
}


