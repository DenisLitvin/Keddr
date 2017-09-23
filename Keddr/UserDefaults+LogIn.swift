//
//  UserDefaults+LogIn.swift
//  Keddr
//
//  Created by macbook on 21.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoginScreenShown
    }
    
    func setIsLoginScreenShown(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoginScreenShown.rawValue)
        synchronize()
    }
    
    func isLoginScreenShown() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoginScreenShown.rawValue)
    }
    
}
