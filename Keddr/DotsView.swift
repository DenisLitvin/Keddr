//
//  DotsView.swift
//  Keddr
//
//  Created by macbook on 20.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class DotsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var numberOfDots = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        for dot in 0..<numberOfDots {
            let dotPath = UIBezierPath(roundedRect: CGRect(x: 13 * dot, y: 0, width: 10, height: 10), cornerRadius: 5)
            Color.lightGray.set()
            dotPath.fill()
        }
    }
}







