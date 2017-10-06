//
//  Font.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

extension Int{
    func getCGFloatIncreasedByUserSettings() -> CGFloat{
        let multiplier = UserDefaults.standard.getUserTextSizeMultiplier()
        let floatSelf = Float(self)
        return CGFloat(floatSelf + floatSelf * multiplier)
    }
}
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
            return 19.getCGFloatIncreasedByUserSettings()
        case .description:
            return 17.getCGFloatIncreasedByUserSettings()
        case .date:
            return 12.getCGFloatIncreasedByUserSettings()
        case .author:
            return 15.getCGFloatIncreasedByUserSettings()
        case .commentBubble:
            return 13.getCGFloatIncreasedByUserSettings()
        case .category:
            return 11.getCGFloatIncreasedByUserSettings()
        case .menu:
            return 17.getCGFloatIncreasedByUserSettings()
        case .replyButton:
            return 16.getCGFloatIncreasedByUserSettings()
        case .signInButton:
            return 16.getCGFloatIncreasedByUserSettings()
        }
    }
    var name: String {
        switch self {
        case .signInButton, .menu, .date:
            return "Avenir-Medium"
        case .description:
            return "AvenirNext-Regular"
        default:
            return "AvenirNext-Bold"
        }
    }
    func create() -> UIFont{
        return UIFont(name: self.name, size: self.size)!
    }
}





