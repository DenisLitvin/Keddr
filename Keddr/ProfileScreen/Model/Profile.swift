//
//  Profile.swift
//  Keddr
//
//  Created by macbook on 27.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

class Profile {
    
    var userDevices: String?
    var onSiteTime: String?
    var commentCount: String?
    var postCount: String?
    var description: String = ""
    var name: String?
    var thumbnailImageUrlString: String?
    var thumbnailBackgroundImageUrlString: String?
    
    init(html: HTMLDocument) {
        if let userDeviceNode = html.at_css("div.user-info > div.user-device > div"){
            self.userDevices = userDeviceNode.text
        }
        if let onSiteTimeNode = html.at_css("div.user-info > div.user-info-item > div:nth-child(2)"){
            self.onSiteTime = onSiteTimeNode.text
        }
        if let commentCountNode = html.at_css("div.user-info > div.user-info-item > div:nth-child(3)"){
            self.commentCount = commentCountNode.text
        }
        if let postCountNode = html.at_css("div.user-info > div.user-info-item > div:nth-child(4)"){
            self.postCount = postCountNode.text
        }
        if let descriptionNode = html.at_css("div.authorBox > div > div.authorDesc"), let text = descriptionNode.text{
            self.description = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let nameNode = html.at_css("div.profile-bg > div > div.user-name"){
            self.name =  nameNode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let thumbnailNode = html.at_css("#user-avatar-link > img"){
            thumbnailImageUrlString = thumbnailNode["src"]
        }
        if let backgroundNode = html.at_css("#user-profile-cover"){
            thumbnailBackgroundImageUrlString = backgroundNode["src"]
        }
    }
}















