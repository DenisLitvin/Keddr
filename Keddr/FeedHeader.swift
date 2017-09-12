//
//  FeedHeader.swift
//  Keddr
//
//  Created by macbook on 01.09.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class FeedHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var content: Post? {
        didSet{
            guard let content = content else { return }
            setupContent(with: content)
        }
    }
    func setupContent(with: Post){
        guard let thumbnailUrl = with.thumbnailImageUrl,
        let date = with.date else { return }
        authorNameLabel.text = with.authorName
        thumbnailView.loadImageUsingUrlString(thumbnailUrl, postUrl: with.url!)
        dateLabel.text = date
    }
    var thumbnailViewTopAnchor: NSLayoutConstraint?
    lazy var thumbnailView: CustomImageView = { [unowned self] in
        let view = CustomImageView()
        view.contentMode = .scaleAspectFill
//        view.backgroundColor = .red
        return view
    }()
    let authorAvatarView: CustomImageView = {
        let view = CustomImageView()
        view.image = #imageLiteral(resourceName: "asus")
//        view.backgroundColor = .yellow
        view.layer.cornerRadius =  18
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    let authorNameLabel: UILabel = {
        let view = UILabel()
//        view.backgroundColor = .green
        view.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        view.textColor = UIColor(red: 0.1294, green: 0.1294, blue: 0.1294, alpha: 1.0)
        return view
    }()
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = UIColor(red: 0.3176, green: 0.3176, blue: 0.3176, alpha: 1.0)
        view.font = UIFont(name: "AvenirNext-Regular", size: 11)
//        view.backgroundColor = .cyan
        return view
    }()
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 0.5
        view.clipsToBounds = true
        return view
    }()
    func setupViews(){
        addSubview(thumbnailView)
        addSubview(authorNameLabel)
        addSubview(authorAvatarView)
        addSubview(dateLabel)
        addSubview(separatorLine)

        thumbnailViewTopAnchor = thumbnailView.anchorWithReturnAnchors(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.bounds.width * 9 / 16)[3]
        authorAvatarView.anchor(top: thumbnailView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
         authorNameLabel.anchor(top: authorAvatarView.centerYAnchor, left: authorAvatarView.rightAnchor, bottom: nil, right: dateLabel.rightAnchor, topConstant: -20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        dateLabel.anchor(top: authorAvatarView.centerYAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 40)
        separatorLine.anchor(top: authorAvatarView.bottomAnchor, left: centerXAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: -25, bottomConstant: 8, rightConstant: 0, widthConstant: 50, heightConstant: 1)
    }
    var previousDelta: CGFloat = 0
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! StretchyHeaderAttributes
        
        let delta = attributes.deltaY
        if previousDelta != delta {
            thumbnailViewTopAnchor?.constant =  (self.bounds.width * 9 / 16) + delta 
            previousDelta = delta
        }
    }
}
