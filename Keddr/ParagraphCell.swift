//
//  ParagraphCell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ParagraphCell: PostDetailsBaseCell {
    
    let view: UITextView = {
        let view = UITextView()
        view.textColor = Color.darkGray
        view.isScrollEnabled = false
        view.isEditable = false
        view.font = Font.description.create()
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.fillSuperview()
    }
    override func setupContent(with element: PostElement){
        super.setupContent(with: element)
        view.text = element.content
        
    }
}
