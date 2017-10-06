//
//  SettingsItem.swift
//  Keddr
//
//  Created by macbook on 03.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

struct SettingsItem {
    
    var content: String?
    var type: SettingsItemType
    
    init(type: SettingsItemType, content: String? = nil) {
        self.type = type
        self.content = content
    }
}

enum SettingsItemType: String{
    case slider
    case text
    case button
}















