//
//  CategoryCell.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CategoryCell: BaseCell {
    
    let textView: UILabel = {
        let view = UILabel()
        view.backgroundColor = Color.keddrYellow
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.font = Font.category.create()
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
