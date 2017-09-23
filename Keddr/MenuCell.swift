//
//  MenuCell.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    var menuItem: MenuItem?{
        didSet{
            guard let menuItem = menuItem else { return }
            textView.text = menuItem.text
            imageView.image = menuItem.image
        }
    }
    
    let imageView: CSImageView = {
        let view = CSImageView()
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.alpha = 0.7
        return view
    }()
    let textView: UILabel = {
        let view = UILabel()
        view.font = Font.menu.create()
        view.textColor = UIColor.white
        view.textAlignment = .left
        view.alpha = 0.9
        return view
    }()
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.2
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(textView)
        addSubview(separatorLineView)
        
        imageView.anchor(top: textView.centerYAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: -13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 26, heightConstant: 26)
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        separatorLineView.anchor(top: nil, left: textView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: self.bounds.width * 0.2 + 30, widthConstant: 0, heightConstant: 1)
    }
}
