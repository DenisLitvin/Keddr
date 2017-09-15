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
    static func fetchPosts(for category: PostCategory, page: Int, complition: @escaping ([Post]) -> ()){
        
    }
    static func fetchPosts(for page: Int, complition: @escaping ([Post]) -> () ) {
        var resultPosts = [Post]()
        
//        let url2 = URL(string: "https://keddr.com/wp-login.php")
//        let httpBody = "log=denlitvinn&pwd=RmqxQiBN2Q1x&testcookie=1"
//        var urlrequest = URLRequest(url: url2!)
//        urlrequest.httpMethod = "POST"
//        urlrequest.httpShouldHandleCookies = true
//        urlrequest.httpBody = httpBody.data(using: .utf8)
//        urlrequest.allHTTPHeaderFields = [
//            "Host": "keddr.com",
//            "Connection" : "keep-alive",
//            "Content-Length": "44",
//            "Accept": "*/*",
//            "Origin": "https://keddr.com",
//            "X-Requested-With": "XMLHttpRequest",
//            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//            "Referer": "https://keddr.com/",
//            "Accept-Encoding": "gzip, deflate, br",
//            "Accept-Language": "ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4"
//        ]
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let urlProfile = URL(string: "https://keddr.com/profile")
//
//        let datatask = session.dataTask(with: urlrequest) { (data, response, error) in
//            if let error = error {
//                print(error)
//            }
//            if let response = response as? HTTPURLResponse{
//                print("headers:", response.allHeaderFields as! [String:String])
//                print()
//                print("status code:", response.statusCode)
//                print()
//                print("cookies:", config.httpCookieStorage?.cookies)
//            }
//            let datatask2 = session.dataTask(with: urlProfile!) { (data, profile, error) in
//                let data = HTML(html: data!, encoding: .utf8)
//                print(data!.at_css("body > div.sitecontainer.container > div.mainbody > div > div.maincontent.page.blogpost.maincontent > div.profile-bg > div > div.user-name")?.text)
//                print((data?.body?.toHTML)!)
//            }
//            datatask2.resume()
//
//        }
//        datatask.resume()
        
        
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


