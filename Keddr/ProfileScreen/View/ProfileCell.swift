//
//  ProfileCell.swift
//  Keddr
//
//  Created by macbook on 27.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ProfileCell: BaseCell {
    
    var post: Post?{
        didSet{
            setupContent()
        }
    }
    
    let thumbnailView: CSImageView = {
        let view = CSImageView()
        return view
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailView)
        thumbnailView.fillSuperview()
    }
    func setupContent(){
        guard let url = post?.thumbnailImageUrlString else { return }
        thumbnailView.loadImageUsingUrlString(url)
    }
}
