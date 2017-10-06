//
//  CSActivityView.swift
//  Keddr
//
//  Created by macbook on 30.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSActivityView: UIVisualEffectView {
    
    init() {
        let effect = UIBlurEffect(style: .dark)
        super.init(effect: effect)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var vibrancyView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: self.effect as! UIBlurEffect)
        let view = UIVisualEffectView(effect: vibrancyEffect)
        return view
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = Font.date.create()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Color.keddrYellow
        return label
    }()
    func setupViews(){
        self.contentView.addSubview(vibrancyView)
        self.contentView.addSubview(textLabel)
        
        vibrancyView.fillSuperview()
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.alpha = 0
    }
}











