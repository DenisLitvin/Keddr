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
    
    var size: CGFloat {
        switch self {
        case .title:
            return 19
        case .description:
            return 16
        case .date:
            return 12
        case .author:
            return 15
        case .commentBubble:
            return 13
        case .category:
            return 11
        case .menu:
            return 25
        }
    }
    var name: String {
        switch self {
        case  .menu:
            return "AvenirNext-Regular"
        case .description, .date:
            return "AvenirNext-Medium"
        default:
            return "AvenirNext-Bold"
        }
    }
}





