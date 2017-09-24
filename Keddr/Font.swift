//
//  Font.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

enum PostCategory: String {
    case Tape
    case Blogs
    case About
}
enum Font {
    case title
    case description
    case date
    case author
    case commentBubble
    case category
    case menu
    case replyButton
    case signInButton
    
    var size: CGFloat {
        switch self {
        case .title:
            return 19
        case .description:
            return 17
        case .date:
            return 12
        case .author:
            return 15
        case .commentBubble:
            return 13
        case .category:
            return 11
        case .menu:
            return 17
        case .replyButton:
            return 16
        case .signInButton:
            return 16
        }
    }
    var name: String {
        switch self {
        case .signInButton:
            return "Avenir-Medium"
        case .menu, .description, .date:
            return "AvenirNext-Regular"
        default:
            return "AvenirNext-Bold"
        }
    }
    func create() -> UIFont{
        return UIFont(name: self.name, size: self.size)!
    }
}





