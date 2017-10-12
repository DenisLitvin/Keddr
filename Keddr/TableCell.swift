//
//  TableCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class TableCell: PostDetailsBaseCell {
    let view: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.font = UIFont(name: Font.description.name, size: Font.description.size)
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
