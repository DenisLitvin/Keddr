//
//  FeedElement.swift
//  Keddr
//
//  Created by macbook on 25.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

enum ElementType: String{
    case p
    case h2
    case fotorama
    case image
    case video
    case table
}
class FeedElement{
    
    var type: ElementType
    var content: String
    
    init(type: ElementType, content: String){
        self.type = type
        self.content = content
    }
    convenience init?(savedFeedElement: SavedFeedElement) {
        guard let content = savedFeedElement.content,
            let type = savedFeedElement.type else { return nil}
        self.init(type: ElementType(rawValue: type)!, content: content)
    }
}

