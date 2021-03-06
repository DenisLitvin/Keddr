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
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let textContainer: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        return view
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailView)
        addSubview(textContainer)
        
        thumbnailView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 10, leftConstant: 6, bottomConstant: 10, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        textContainer.anchor(top: topAnchor, left: thumbnailView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 3, bottomConstant: 0, rightConstant: 3, widthConstant: 0, heightConstant: 0)
    }
    func setupContent(){
        guard let url = post?.thumbnailImageUrlString,
        let date = post?.date,
        let title = post?.title,
        let description = post?.description
        else { return }
        thumbnailView.loadImageUsingUrlString(url)
        updateText(date: date.beautyDate(), title: title, description: description)
    }
    func updateText(date: String, title: String, description: String){
        let date = (date + "\n")
        let title = (title + "\n")
        let attributedText = NSMutableAttributedString(string: date, attributes: [NSAttributedStringKey.foregroundColor: Color.lightGray, NSAttributedStringKey.font: UIFont(name: Font.date.name, size: Font.date.size - 2)!])
        attributedText.append(NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: Color.darkGray, NSAttributedStringKey.font: UIFont(name: Font.title.name, size: Font.title.size - 4)!]))
        self.textContainer.attributedText = attributedText
    }
}
