//
//  Font.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

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
            return 18
        case .description:
            return 15
        case .date:
            return 11
        case .author:
            return 14
        case .commentBubble:
            return 12
        case .category:
            return 10
        case .menu:
            return 25
        }
    }
    var name: String {
        switch self {
        case .description, .date, .menu:
            return "AvenirNext-Regular"
        default:
            return "AvenirNext-DemiBold"
        }
    }
}





