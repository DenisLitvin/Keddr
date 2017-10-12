//
//  String+percentEncoded.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
extension String {
    func percentEncoded() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
