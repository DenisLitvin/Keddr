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
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(view)
        view.fillSuperview()
    }
    override func setupContent(with: FeedElement) {
        super.setupContent(with: with)
        let url = URL(string: with.content)
        view.load(URLRequest(url: url!))
    }
}

