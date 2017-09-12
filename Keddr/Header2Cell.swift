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
        view.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
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
