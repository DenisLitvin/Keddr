//
//  BaseCell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class PostDetailsBaseCell: BaseCell {
    
    var post: Post?
    
    var content: PostElement? {
        didSet{
            setupContent(with: content!)
        }
    }
    func setupContent(with: PostElement){}
}
