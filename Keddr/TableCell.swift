//
//  TableCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class TableCell: FeedCell {
    let view: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.font = UIFont(name: Font.description.name, size: Font.description.size)
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
