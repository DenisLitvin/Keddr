//
//  UIViewController+CODEINJECTION.swift
//  Keddr
//
//  Created by Денис Литвин on 01.12.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

//MARK: CODE INJECTION
extension UIViewController {
    
    #if DEBUG
    @objc func injected() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        viewDidLoad()
    }
    #endif
}
