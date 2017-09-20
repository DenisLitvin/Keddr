//
//  Int+isSuccessfulHttpCode.swift
//  Keddr
//
//  Created by macbook on 20.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension Int {
    public var isSuccessHttpCode: Bool {
        return 200 <= self && self < 300
    }
}
