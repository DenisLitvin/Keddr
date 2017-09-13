//
//  ParagraphCell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ParagraphCell: FeedCell {
    
    let view: UITextView = {
        let view = UITextView()
        view.textColor = Color.darkGray
        view.font = UIFont(name: Font.description.name, size: Font.description.size)
        view.isUserInteractionEnabled = false
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.fillSuperview()
    }
    override func setupContent(with element: FeedElement){
        super.setupContent(with: element)
        view.text = element.content
        
    }
}
