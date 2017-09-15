//
//  FeedCell.swift
//  Keddr
//
//  Created by macbook on 22.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func handleSaveTapped(with: Post, save: Bool)
}
class PostCell: BaseCell {
    
    weak var delegate: PostCellDelegate?
    
    let thumbnailView: CustomImageView = {
        let view = CustomImageView()
        view.image = #imageLiteral(resourceName: "asus")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 19
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
        view.layer.cornerRadius = 19
        view.backgroundColor = .white
        view.drawShadow()
        return view
    }()
    let textContainer: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 19
        view.isEditable = false
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        view.textContainer.lineBreakMode = .byCharWrapping
        return view
    }()
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = Color.lightGray
        view.font = UIFont(name: Font.date.name, size: Font.date.size)
        return view
    }()
    let authorNameLabel: UILabel = {
        let view = UILabel()
        //        view.text = "Александр Ляпота"
        view.font = UIFont(name: Font.author.name, size: Font.author.size)
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
    let commentView: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Color.keddrYellow
        button.setImage(#imageLiteral(resourceName: "chatBubble"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Font.commentBubble.name, size: Font.commentBubble.size)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.titleEdgeInsets = UIEdgeInsets(top: -6, left: -75, bottom: 0, right: 4)
        return button
    }()
    var categoryViewWidthAnchor: NSLayoutConstraint?
    let categoryView: UILabel = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.textAlignment = .center
        view.font = UIFont(name: Font.category.name, size: Font.category.size)
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
            delegate?.handleSaveTapped(with: post, save: true)
        } else {
            delegate?.handleSaveTapped(with: post, save: false)
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
            thumbnailView.loadImageUsingUrlString(thumbnailUrl, postUrl: post.url!)
            updateText(title: title, description: description)
            dateLabel.text = date.beautyDate()
            authorNameLabel.text = post.authorName
            commentView.setTitle(commentCount, for: .normal)
            categoryView.text = categories.first?.uppercased()
            let authorNameWidth = authorNameLabel.sizeThatFits(CGSize(width: 300, height: 30)).width
            let widthToSubtract = post.authorName == "" ? 60 : authorNameWidth
            let width = calculateSize(for: [categories.first!], height: 21, width: self.bounds.width - 130 - widthToSubtract, positioning: .horizontal, fontName: [Font.category.name], fontSize: [Font.category.size + 2], removeIfNotFit: true).size.width
            categoryViewWidthAnchor?.constant = width == 0 ? 0 : width + 12
            
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
            let attributedText = NSMutableAttributedString(string: title, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: UIFont(name: Font.title.name, size: Font.title.size)!])
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 1
            let range = NSMakeRange(0, attributedText.string.characters.count)
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range)
            attributedText.append(NSAttributedString(string: description, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: UIFont(name: Font.description.name, size: Font.description.size)!]))
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
        bottomContainerView.addSubview(commentView)
        
        circleButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 34, heightConstant: 34)
        categoryViewWidthAnchor = categoryView.anchorWithReturnAnchors(top: authorAvatarView.centerYAnchor, left: nil, bottom: nil, right: commentView.leftAnchor, topConstant: -11, leftConstant: 8, bottomConstant: 0, rightConstant: 10, widthConstant: 10, heightConstant: 27)[2]
        authorAvatarView.anchor(top: textContainer.bottomAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 38, heightConstant: 38)
        dateLabel.anchor(top: authorAvatarView.centerYAnchor, left: authorAvatarView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18)
        topContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: bounds.width * 9 / 16)
        thumbnailView.fillSuperview()
        bottomContainerView.anchor(top: topContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomContainerView.heightAnchor.constraint(equalTo: textContainer.heightAnchor, constant: 76).isActive = true
        commentView.anchor(top: authorAvatarView.centerYAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: -14, leftConstant: 0, bottomConstant: 0, rightConstant: 11, widthConstant: 39, heightConstant: 38)
        authorNameLabel.anchor(top: nil, left: authorAvatarView.rightAnchor, bottom: authorAvatarView.centerYAnchor, right: categoryView.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    func animateViews(num: Double){
    }
}






