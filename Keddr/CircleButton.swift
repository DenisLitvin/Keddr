//
//  CircleButton.swift
//  Keddr
//
//  Created by macbook on 03.09.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CircleButton: CSButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let midPoint = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let circle = UIBezierPath(arcCenter: midPoint, radius: 12, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let innerCircle = UIBezierPath(arcCenter: midPoint, radius: 9, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setStroke()
        let fillColor = isOn ? Color.keddrYellow.withAlphaComponent(0.9) : UIColor.clear
        fillColor.setFill()
        circle.lineWidth = 7
        circle.stroke()
        innerCircle.fill()
    }    
    override func setupAppearance(){
        drawShadow()
        //        backgroundColor = isOn ? UIColor(red: 247/255, green: 206/255, blue: 10/255, alpha: 0.9) : .clear
        //        layer.borderWidth = 8
        //        layer.cornerRadius = 17
        //        layer.masksToBounds = true
        //        layer.borderColor = UIColor.white.cgColor
    }
}







