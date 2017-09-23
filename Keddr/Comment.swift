//
//  Comment.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

fileprivate var commentNestLevels = [String:Int]()

class Comment {
    
    var content: String?
    var authorName: String?
    var authorAvatarUrlString: String?
    var timeStamp: String?
    var nestLevel: Int?
    var commentId: String?
    var parentId: String?
    var commentVotes: String?
    var postId: String?
    
    init?(xml: XMLElement) {
        guard let commentId = xml["id"]?.replacingOccurrences(of: "comment-", with: ""),
            let parentId = xml["parent-id"] else { return nil}
        self.commentId = commentId
        self.parentId = parentId
        if parentId == "0"{
            nestLevel = 1
            commentNestLevels[commentId] = 1
        } else if let parentLevel = commentNestLevels[parentId]{
            let selfLevel = parentLevel + 1
            nestLevel = selfLevel
            commentNestLevels[commentId] = selfLevel
        }
        if let timeNode = xml.at_css("a > time"){
            self.timeStamp = timeNode["datetime"]
        }
        if let authorAvatarNode = xml.at_css("span > img"){
            self.authorAvatarUrlString = authorAvatarNode["src"]
        }
        if let testNode = xml.at_css("div.decomments-comment-body > div > div.decomments-title-block"){
            if let authorNameNode = testNode.at_css("a.decomments-autor-name"){
                self.authorName = authorNameNode.text
            } else if let authorNameNode = testNode.at_css("span.decomments-autor-name"){
                self.authorName = authorNameNode.text
            }
        }
        var contentString = ""
        if let contentNode = xml.at_css("div.decomments-comment-main > div"){
            for content in contentNode.css("p"){
                if let text = content.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != ""{
                    contentString += "\(text)\n"
                }
            }
        }
        self.content = contentString
        if let voteNode = xml.at_css("div.decomments-comment-body > div > nav > span > span > b"){
            let text = voteNode.text == "" ? "0" : voteNode.text
            self.commentVotes = text
        }
    }
}






