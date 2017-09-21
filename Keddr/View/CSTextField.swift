//
//  CSTextField.swift
//  Keddr
//
//  Created by macbook on 20.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSTextField: UITextField {
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 5, y: 0, width: bounds.width - 5, height: bounds.height)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 5, y: 0, width: bounds.width - 5, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 5, y: 0, width: bounds.width - 5, height: bounds.height)
    }
}










