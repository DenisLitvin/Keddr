//
//  DateFormatter+beautyDate.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation

extension Date {
    func beautyDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: self)
    }
}
