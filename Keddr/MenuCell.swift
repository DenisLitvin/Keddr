//
//  MenuCell.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    let textView: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: Font.menu.name, size: Font.menu.size)
        view.textColor = UIColor.white
        view.textAlignment = .center
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        textView.fillSuperview()
    }
}
