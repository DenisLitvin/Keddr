//
//  File.swift
//  Keddr
//
//  Created by macbook on 25.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension Api{
    static func fetchFeed(url: URL, complition: @escaping ([FeedElement])->() ){
        var feed = [FeedElement]()
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                if let data = data, let htmlFeed = HTML(html: data, encoding: .utf8){
                    for node in htmlFeed.css("p, h2, div, ul"){
                        if node.parent?.className != "blogcontent" || node.className == "leftblogcontent" || node.className == "mistape_caption"{
                            continue
                        }
                        //feed
                        if let image = node.at_css("img")?["src"], node.tagName == "p"{
                            if let image = node.at_css("a")?["href"], image.hasSuffix("jpg"){
                                for node in node.css("a"){
                                    let image = node["href"]!
                                    feed.append(FeedElement(type: .image, content: image.encodedCharacters()))
                                }
                                continue
                            }
                            feed.append(FeedElement(type: .image, content: image.encodedCharacters()))
                        }
                        if node.tagName == "ul"{
                            var characteristicsField = ""
                            for li in node.css("li"){
                                characteristicsField += ("○ \(li.text!)\n")
                            }
                            feed.append(FeedElement(type: .table, content: characteristicsField.trimmingCharacters(in: .whitespacesAndNewlines)))
                        }
                        if node.tagName == "p", node.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "", node.text != nil, let text = node.text{
                            feed.append(FeedElement(type: .p, content: text))
                        }
                        if node.tagName == "h2", node.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "", node.text != nil, let text = node.text{
                            feed.append(FeedElement(type: .h2, content: text))
                        }
                        if let video = node.at_css("iframe")?["src"], node.tagName == "p"{
                            feed.append(FeedElement(type: .video, content: video.encodedCharacters()))
                        }
                        if node.tagName == "div", node.className == "fotorama"{
                            var fotorama = ""
                            for image in node.css("a"){
                                if let image = image["href"]{
                                    fotorama += "\(image.encodedCharacters()),"
                                }
                            }
                            let fotoramaTrimmed = fotorama.characters.dropLast()
                            feed.append(FeedElement(type: .fotorama, content: String(fotoramaTrimmed)))
                        }
                    }
                }
                DispatchQueue.main.async {
                    complition(feed)
                }
                }.resume()
        }
        
    }
}





