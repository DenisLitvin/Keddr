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
    var authorAvatarUrl: String?
    var timeStamp: String?
    var nestedLevel: Int?
    var id: String?
    var parentId: String?
    
    init?(xml: XMLElement) {
        guard let commentId = xml["id"]?.replacingOccurrences(of: "comment-", with: ""),
            let parentId = xml["parent-id"] else { return nil}
        self.id = commentId
        self.parentId = parentId
        if parentId == "0"{
            nestedLevel = 1
            commentNestLevels[commentId] = 1
        } else if let parentLevel = commentNestLevels[parentId]{
            let selfLevel = parentLevel + 1
            nestedLevel = selfLevel
            commentNestLevels[commentId] = selfLevel
        }
        if let timeNode = xml.at_css("a > time"){
            self.timeStamp = timeNode["datetime"]
        }
        if let authorAvatarNode = xml.at_css("span > img"){
            self.authorAvatarUrl = authorAvatarNode["src"]
        }
        if let authorNameNode = xml.at_css("div.decomments-title-block > a.decomments-autor-name"), let className = xml.className, className.contains("comment byuser"){
            self.authorName = authorNameNode.text
        } else if let authorNameNode = xml.at_css("div.decomments-title-block > span"){
            self.authorName = authorNameNode.text
        }
        if let contentNode = xml.at_css(" div.decomments-comment-main > div > p"){
            self.content = contentNode.text
        }        //        print("comment-id:", commentId,"     parent-id:", parentId)
    }
}





