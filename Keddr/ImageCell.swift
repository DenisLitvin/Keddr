//
//  ImageCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ImageCell: PostDetailsCell {
    
    let view: CSImageView = {
        let view = CSImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 7
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 5, bottomConstant: 3, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    override func setupContent(with: PostElement) {
        super.setupContent(with: with)
        view.loadImageUsingUrlString(with.content, directoryPathUrl: (post?.url)!)
    }
}
