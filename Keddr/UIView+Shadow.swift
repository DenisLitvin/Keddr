//
//  UIView+Shadow.swift
//  Keddr
//
//  Created by macbook on 27.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

extension UIView{
    func drawShadow(){
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
    }
}

