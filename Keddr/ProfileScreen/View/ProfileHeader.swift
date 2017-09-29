//
//  ProfileHeader.swift
//  Keddr
//
//  Created by macbook on 28.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    var profile: Profile? {
        didSet{
            guard let profile = profile else { return }
            setupContent(with: profile)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var thumbnailViewHeightAnchor: NSLayoutConstraint?
    let thumbnailBackgroundView: CSImageView = {
        let view = CSImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    let thumbnailView: CSImageView = {
        let view = CSImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 40
        return view
    }()
    let authorNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.font = Font.title.create()
        return view
    }()
    var authorDescriptionLabelHeightConstraint: NSLayoutConstraint?
    let authorDescriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.description.create()
        return view
    }()
    var devicesLabelHeightConstraint: NSLayoutConstraint?
    let devicesLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.description.create()
        return view
    }()
    var statisticsLabelHeightConstraint: NSLayoutConstraint?
    let statisticsLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Font.description.create()
        return view
    }()
    let postsSectionHeaderLabel: UILabel = {
        let view = UILabel()
        view.font = Font.title.create()
        view.text = "Посты:"
        return view
    }()
    func setupContent(with profile: Profile){
        guard let name = profile.name,
            let devices = profile.userDevices,
            let onSiteTime = profile.onSiteTime,
            let postCount = profile.postCount,
            let commentCount = profile.commentCount,
            let thumbnailUrlString = profile.thumbnailImageUrlString,
            let thumbnailBackgroundUrlString = profile.thumbnailBackgroundImageUrlString
            else { return }
        authorNameLabel.text = name
        authorDescriptionLabel.text = profile.description
        let devicesLabelText = "Мои девайсы: \n" + devices
        devicesLabel.text = devicesLabelText
        let statisticsLabelText = "Статистика: \n" + (onSiteTime + "\n" + commentCount + "\n" + postCount)
        statisticsLabel.text = statisticsLabelText
        thumbnailBackgroundView.loadImageUsingUrlString(thumbnailBackgroundUrlString)
        thumbnailView.loadImageUsingUrlString(thumbnailUrlString)
        calculateLabelHeightConstraint(with: profile.description, constraint: authorDescriptionLabelHeightConstraint)
        calculateLabelHeightConstraint(with: devicesLabelText, constraint: devicesLabelHeightConstraint)
        calculateLabelHeightConstraint(with: statisticsLabelText, constraint: statisticsLabelHeightConstraint)
        //textSize
    }
    func calculateLabelHeightConstraint(with text: String, constraint: NSLayoutConstraint?) {
        guard let constraint = constraint else { return }
        let width = self.bounds.width - 10
        constraint.constant = TextSize.calculate(for: [text], height: 9999, width: width, positioning: .vertical, fontName: [Font.description.name], fontSize: [Font.description.size], removeIfNotFit: false).size.height + 10
    }
    func setupViews(){
        addSubview(thumbnailBackgroundView)
        addSubview(thumbnailView)
        addSubview(authorNameLabel)
        addSubview(authorDescriptionLabel)
        addSubview(devicesLabel)
        addSubview(statisticsLabel)
        addSubview(postsSectionHeaderLabel)
        
        thumbnailViewHeightAnchor = thumbnailBackgroundView.anchorWithReturnAnchors(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: (self.bounds.width * 9 / 16))[3]
        thumbnailView.anchor(top: thumbnailBackgroundView.centerYAnchor, left: thumbnailBackgroundView.centerXAnchor, bottom: nil, right: nil, topConstant: -42, leftConstant: -42, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        authorNameLabel.anchor(top: thumbnailBackgroundView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        authorDescriptionLabelHeightConstraint = authorDescriptionLabel.anchorWithReturnAnchors(top: authorNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 1)[3]
        devicesLabelHeightConstraint = devicesLabel.anchorWithReturnAnchors(top: authorDescriptionLabel.bottomAnchor, left: authorDescriptionLabel.leftAnchor, bottom: nil, right: authorDescriptionLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)[3]
        statisticsLabelHeightConstraint = statisticsLabel.anchorWithReturnAnchors(top: devicesLabel.bottomAnchor, left: authorDescriptionLabel.leftAnchor, bottom: nil, right: authorDescriptionLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)[3]
        postsSectionHeaderLabel.anchor(top: statisticsLabel.bottomAnchor, left: authorDescriptionLabel.leftAnchor, bottom: nil, right: authorDescriptionLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    var previousDelta: CGFloat = 0
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! StretchyHeaderAttributes
        
        let delta = attributes.deltaY
        if previousDelta != delta {
            thumbnailViewHeightAnchor?.constant = (self.bounds.width * 9 / 16) + delta
            previousDelta = delta
        }
    }
}




















