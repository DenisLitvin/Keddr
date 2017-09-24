//
//  CSButton.swift
//  Keddr
//
//  Created by macbook on 23.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    var isOn = false { didSet { setupAppearance(); setNeedsDisplay() } }
    
    func setupAppearance(){
       
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.3
        }
        return true
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isOn = !isOn
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
}
