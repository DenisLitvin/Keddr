//
//  ImageCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ImageCell: FeedCell {
    
    let view: CustomImageView = {
        let view = CustomImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    override func setupContent(with: FeedElement) {
        super.setupContent(with: with)
        view.loadImageUsingUrlString(with.content, postUrl: (post?.url)!)
    }
}
