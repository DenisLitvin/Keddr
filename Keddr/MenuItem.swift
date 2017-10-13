//
//  MenuItem.swift
//  Keddr
//
//  Created by macbook on 22.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

struct MenuItem {
    var text: String
    let iconType: MenuIconType
}
enum MenuIconType: String {
    case tape
    case blogs
    case saved
    case settings
    case profile
    case signOut
}







