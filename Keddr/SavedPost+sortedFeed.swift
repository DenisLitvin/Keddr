//
//  SavedPost+sortedFeed\.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension SavedPost {
    func sortFeed() -> [SavedFeedElement]{
        if let feedElements = self.savedFeedElements,
            let array = Array(feedElements) as? [SavedFeedElement]{
            let sortedArray = array.sorted { $0.position < $1.position }
            return sortedArray
        }
        return []
    }
}





