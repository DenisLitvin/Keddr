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
            iconView.iconType = menuItem.iconType
        }
    }
    
    let iconView: CSDrawnIconView = {
        let view = CSDrawnIconView()
        return view
    }()
    let textView: UILabel = {
        let view = UILabel()
        view.font = Font.menu.create()
        view.textColor = Color.lightGray
        view.textAlignment = .left
        return view
    }()
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        view.alpha = 0.2
        return view
    }()
    override var isSelected: Bool {
        didSet{
            let color = isSelected ? Color.keddrYellow : Color.lightGray
            self.iconView.iconColor = color
            self.textView.textColor = color
        }
    }
    override func setupViews() {
        super.setupViews()
        addSubview(iconView)
        addSubview(textView)
        addSubview(separatorLineView)
        
        iconView.anchor(top: textView.centerYAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: -13, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        textView.anchor(top: topAnchor, left: iconView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        separatorLineView.anchor(top: nil, left: textView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: self.bounds.width * 0.2 + 30, widthConstant: 0, heightConstant: 1)
    }
}
