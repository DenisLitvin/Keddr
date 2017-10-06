//
//  Header2Cell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class Header2Cell: PostDetailsCell {
    
    let view: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.textColor = Color.darkGray
        view.font = Font.title.create()
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.fillSuperview()
    }
    override func setupContent(with: PostElement) {
        super.setupContent(with: with)
        view.text = with.content
    }
}
