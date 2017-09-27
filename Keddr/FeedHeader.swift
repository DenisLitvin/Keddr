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
        guard let thumbnailUrl = with.thumbnailImageUrlString,
        let date = with.date,
        let url = with.url,
        let categories = with.categories else { return }
        authorNameLabel.text = with.authorName
        thumbnailView.loadImageUsingUrlString(thumbnailUrl, directoryPathUrl: url)
        dateLabel.text = date.beautyDate()
        categorySlider.categories = categories
    }
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    var thumbnailViewTopAnchor: NSLayoutConstraint?
    lazy var thumbnailView: CSImageView = { [unowned self] in
        let view = CSImageView()
        view.contentMode = .scaleAspectFill
//        view.backgroundColor = .red
        return view
    }()
    let authorAvatarView: CSImageView = {
        let view = CSImageView()
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
        view.font = UIFont(name: Font.author.name, size: Font.author.size)
        view.textColor = Color.darkGray
        return view
    }()
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = Color.lightGray
        view.font = UIFont(name: Font.date.name, size: Font.date.size)
//        view.backgroundColor = .cyan
        return view
    }()
    let categorySlider: CategorySlider = {
        let view = CategorySlider()
        return view
    }()
    
    func setupViews(){
        addSubview(thumbnailView)
        addSubview(containerView)
        containerView.addSubview(authorNameLabel)
        containerView.addSubview(authorAvatarView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(categorySlider)

        thumbnailViewTopAnchor = thumbnailView.anchorWithReturnAnchors(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.bounds.width * 9 / 16)[3]
        containerView.anchor(top: thumbnailView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        authorAvatarView.anchor(top: containerView.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
         authorNameLabel.anchor(top: authorAvatarView.topAnchor, left: authorAvatarView.rightAnchor, bottom: nil, right: dateLabel.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 17)
        dateLabel.anchor(top: authorAvatarView.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 17)
        categorySlider.anchor(top: dateLabel.bottomAnchor, left: authorAvatarView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
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
