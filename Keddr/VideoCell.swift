//
//  VideoCell.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import WebKit

class VideoCell: FeedCell {
    
    let view: WKWebView = {
        let view = WKWebView()
        view.scrollView.isScrollEnabled = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 5, bottomConstant: 3, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    override func setupContent(with: FeedElement) {
        super.setupContent(with: with)
        let url = URL(string: with.content)
        view.load(URLRequest(url: url!))
    }
}

