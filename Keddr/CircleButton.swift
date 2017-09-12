//
//  CircleButton.swift
//  Keddr
//
//  Created by macbook on 03.09.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isOn = false { didSet { setupAppearance() } }
    
    func setupAppearance(){
        drawShadow()
        backgroundColor = isOn ? UIColor(red: 247/255, green: 206/255, blue: 10/255, alpha: 0.9) : .clear
        layer.borderWidth = 8
        layer.cornerRadius = 17
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
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
