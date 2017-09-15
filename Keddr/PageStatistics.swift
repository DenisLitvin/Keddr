//
//  PageStatistics.swift
//  Keddr
//
//  Created by macbook on 13.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

struct PageStatistics {
    
    var loadingPageNumber = 0
    var numberOfPagesLoaded = 0
    
    mutating func clear() {
        self.loadingPageNumber = 0
        self.numberOfPagesLoaded = 0
    }
}



