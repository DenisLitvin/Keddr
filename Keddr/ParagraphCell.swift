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
        view.font = UIFont(name: "AvenirNext-Regular", size: 15)
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
