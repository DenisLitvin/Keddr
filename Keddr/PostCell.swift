//
//  FeedCell.swift
//  Keddr
//
//  Created by macbook on 22.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class PostCell: BaseCell {
    
    weak var mainVC: MainVC?
    
    let thumbnailView: CustomImageView = {
        let view = CustomImageView()
        view.image = #imageLiteral(resourceName: "asus")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    let topContainerView: UIView = {
        let view = UIView()
        view.drawShadow()
        return view
    }()
    let bottomContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.drawShadow()
        return view
    }()
    let textContainer: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 20
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        view.textContainer.lineBreakMode = .byWordWrapping
        return view
    }()
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = Color.lightGray
        view.font = Font.date.create()
        return view
    }()
    let authorNameLabel: UILabel = {
        let view = UILabel()
        //        view.text = "Александр Ляпота"
        view.font = Font.author.create()
        view.textColor = Color.darkGray
        return view
    }()
    let authorAvatarView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "asus")
        view.layer.cornerRadius =  18
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    lazy var commentBubble: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.tintColor = Color.lightGray
        button.setImage(#imageLiteral(resourceName: "ChatBubble"), for: .normal)
        button.setTitleColor(Color.lightGray, for: .normal)
        button.titleLabel?.font = Font.commentBubble.create()
        button.titleLabel?.textAlignment = .right
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -70, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(commentBubbleTapped), for: .touchUpInside)
        return button
    }()
    var categoryViewWidthAnchor: NSLayoutConstraint?
    let categoryView: UILabel = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 11
        view.textAlignment = .center
        view.font = Font.category.create()
        view.textColor = .white
        view.backgroundColor = Color.keddrYellow
        return view
    }()
    lazy var circleButton: CircleButton = { [unowned self] _ in
        let button = CircleButton()
        button.addTarget(self, action: #selector(PostCell.saveButtonTapped), for: .touchUpInside)
        return button
    }()
    func saveButtonTapped(_ sender: CircleButton){
        guard let post = post else { return }
        if sender.isOn {
            mainVC?.handleSaveTapped(with: post, save: true)
        } else {
            mainVC?.handleSaveTapped(with: post, save: false)
        }
    }
    var post: Post?{
        didSet{
            setupContent(with: post!)
        }
    }
    func setupContent(with post: Post){
        if let thumbnailUrl = post.thumbnailImageUrl,
            let date = post.date,
            let title = post.title,
            let description = post.description,
            let commentCount = post.commentCount,
            let categories = post.categories {
            thumbnailView.loadImageUsingUrlString(thumbnailUrl, directoryPathUrl: post.url!)
            updateText(title: title, description: description)
            dateLabel.text = date.beautyDate()
            authorNameLabel.text = post.authorName
            commentBubble.setTitle(commentCount, for: .normal)
            categoryView.text = categories.first
            let authorNameWidth = authorNameLabel.sizeThatFits(CGSize(width: 300, height: 30)).width
            let widthToSubtract = post.authorName == "" ? 60 : authorNameWidth
            let width = TextSize.calculate(for: [categories.first!], height: 21, width: self.bounds.width - 136 - widthToSubtract, positioning: .horizontal, fontName: [Font.category.name], fontSize: [Font.category.size + 2], removeIfNotFit: true).size.width
            categoryViewWidthAnchor?.constant = width == 0 ? 0 : width + 14
            
            let savedPost = post.findSavedPost(with: appDelegate.persistentContainer.viewContext)
            if savedPost != nil {
                circleButton.isOn = true
            } else {
                circleButton.isOn = false
            }
        }
    }
    func updateText(title: String, description: String){
        let title = ("\(title)\n")
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: Font.title.create(), NSParagraphStyleAttributeName: NSParagraphStyle.default])
        attributedText.append(NSAttributedString(string: description, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: Font.description.create(), NSParagraphStyleAttributeName: NSParagraphStyle.default]))
        self.textContainer.attributedText = attributedText
    }
    
    override func setupViews(){
        addSubview(topContainerView)
        topContainerView.addSubview(thumbnailView)
        topContainerView.addSubview(circleButton)
        addSubview(bottomContainerView)

        bottomContainerView.addSubview(authorAvatarView)
        bottomContainerView.addSubview(categoryView)
        bottomContainerView.addSubview(authorNameLabel)
        bottomContainerView.addSubview(textContainer)
        bottomContainerView.addSubview(dateLabel)
        bottomContainerView.addSubview(commentBubble)
    
        circleButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 34, heightConstant: 34)
        authorAvatarView.anchor(top: textContainer.bottomAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 38, heightConstant: 38)
        dateLabel.anchor(top: authorAvatarView.centerYAnchor, left: authorAvatarView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18)
        topContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: bounds.width * 9 / 16)
        thumbnailView.fillSuperview()
        bottomContainerView.anchor(top: topContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomContainerView.heightAnchor.constraint(equalTo: textContainer.heightAnchor, constant: 76).isActive = true
        categoryViewWidthAnchor = categoryView.anchorWithReturnAnchors(top: nil, left: nil, bottom: dateLabel.bottomAnchor, right: commentBubble.leftAnchor, topConstant: -13, leftConstant: 8, bottomConstant: 0, rightConstant: 20, widthConstant: 10, heightConstant: 22)[2]
        commentBubble.anchor(top: nil, left: nil, bottom: categoryView.centerYAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -10, rightConstant: 11, widthConstant: 30, heightConstant: 16)
        authorNameLabel.anchor(top: nil, left: authorAvatarView.rightAnchor, bottom: authorAvatarView.centerYAnchor, right: categoryView.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    func animateViews(num: Double){
    }
    func commentBubbleTapped(){
        let layout = UICollectionViewFlowLayout()
        let commentsVC = CommentsVC(collectionViewLayout: layout)
        commentsVC.post = post
        mainVC?.navigationController?.pushViewController(commentsVC, animated: true)
    }
}






