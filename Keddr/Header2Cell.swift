//
//  Header2Cell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class Header2Cell: FeedCell {
    
    let view: UITextView = {
        let view = UITextView()
        view.textColor = Color.darkGray
        view.font = UIFont(name: Font.title.name, size: Font.title.size)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.fillSuperview()
    }
    override func setupContent(with: FeedElement) {
        super.setupContent(with: with)
        view.text = with.content
    }
}
