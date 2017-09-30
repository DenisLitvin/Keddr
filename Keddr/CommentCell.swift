//
//  CommentCell.swift
//  Keddr
//
//  Created by macbook on 16.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
class LikeButton: CSButton {
    override func setupAppearance() {
        super.setupAppearance()
        tintColor = isOn ? .green : Color.lightGray
    }
}
class DislikeButton: CSButton {
    override func setupAppearance() {
        super.setupAppearance()
        tintColor = isOn ? .red : Color.lightGray
    }
}
class CommentCell: BaseCell {
    
    weak var commentsVC: CommentsVC?
    
    var comment: Comment? {
        didSet{
            setupContent()
        }
    }
    
    var bubbleViewWidthConstraint: NSLayoutConstraint?
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.ultraLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    let textContainer: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = Color.ultraLightGray
        return view
    }()
    let dotArrayView: DotsView = {
        let view = DotsView()
        return view
    }()
    let avatarView: CSImageView = {
        let view = CSImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    let votesImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "metrica")
        return view
    }()
    let votesLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = Color.lightGray
        view.font = Font.author.create()
        return view
    }()
    lazy var replyButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Ответить", for: .normal)
        view.setTitleColor(Color.darkGray, for: .normal)
        view.titleLabel?.font = Font.replyButton.create()
        view.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
        return view
    }()
    lazy var likeButton: LikeButton = {
        let view = LikeButton()
        view.setImage(#imageLiteral(resourceName: "thumbUp"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return view
    }()
    lazy var dislikeButton: DislikeButton = {
        let view = DislikeButton()
        view.setImage(#imageLiteral(resourceName: "thumbDown"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        return view
    }()
    let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = UIStackViewDistribution.fillEqually
        view.axis = .horizontal
        return view
    }()
    func setupContent(){
        guard let date = comment?.timeStamp,
            let authorName = comment?.authorName,
            let description = comment?.content,
            let votes = comment?.commentVotes,
            let nestlevel = comment?.nestLevel,
            let authorAvatarUrlString = comment?.authorAvatarUrlString  else { return }
        avatarView.loadImageUsingUrlString(authorAvatarUrlString)
        updateText(date: date, authorName: authorName, description: description)
        votesLabel.text = votes
        //like button appearence
        if let isLiked = comment?.isLiked {
            if isLiked{
                likeButton.isOn = true
            } else {
                dislikeButton.isOn = true
            }
        }
        //draw circles
        dotArrayView.numberOfDots = nestlevel
    }
    func updateText(date: String, authorName: String, description: String){
        let date = ("\(date)\n")
        let authorName = ("\(authorName)\n")
        let attributedText = NSMutableAttributedString(string: date, attributes: [NSAttributedStringKey.foregroundColor: Color.lightGray, NSAttributedStringKey.font: Font.date.create()])
        attributedText.append(NSAttributedString(string: authorName, attributes: [NSAttributedStringKey.foregroundColor: Color.darkGray, NSAttributedStringKey.font: Font.title.create()]))
        attributedText.append(NSAttributedString(string: description, attributes: [NSAttributedStringKey.foregroundColor: Color.darkGray, NSAttributedStringKey.font: Font.description.create()]))
        self.textContainer.attributedText = attributedText
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleView)
        bubbleView.addSubview(textContainer)
        addSubview(dotArrayView)
        addSubview(avatarView)
        addSubview(votesImageView)
        addSubview(votesLabel)
        bubbleView.addSubview(replyButton)
        bubbleView.addSubview(stackView)
        
        let likeContainerView = UIView()
        let dislikeContainerView = UIView()
        
        stackView.addArrangedSubview(likeContainerView)
        stackView.addArrangedSubview(dislikeContainerView)
        addSubview(likeButton)
        addSubview(dislikeButton)
        
        bubbleViewWidthConstraint = bubbleView.anchorWithReturnAnchors(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 10, heightConstant: 0)[3]
        textContainer.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        dotArrayView.anchor(top: avatarView.centerYAnchor, left: leftAnchor, bottom: nil, right: avatarView.rightAnchor, topConstant: -5, leftConstant: 3, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 10)
        avatarView.anchor(top: bubbleView.topAnchor, left: nil, bottom: nil, right: bubbleView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 50, heightConstant: 50)
        votesImageView.anchor(top: avatarView.bottomAnchor, left: nil, bottom: nil, right: avatarView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: -4, widthConstant: 30, heightConstant: 20)
        votesLabel.anchor(top: nil, left: avatarView.centerXAnchor, bottom: votesImageView.bottomAnchor, right: bubbleView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 14)
        replyButton.anchor(top: nil, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 4, rightConstant: 0, widthConstant: 80, heightConstant: 30)
        stackView.anchor(top: nil, left: replyButton.rightAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 5, widthConstant: 0, heightConstant: 16)
        likeButton.anchor(top: likeContainerView.topAnchor, left: likeContainerView.centerXAnchor, bottom: likeContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: -8, bottomConstant: 0, rightConstant: 0, widthConstant: 33, heightConstant: 0)
        dislikeButton.anchor(top: dislikeContainerView.topAnchor, left: dislikeContainerView.centerXAnchor, bottom: dislikeContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: -8, bottomConstant: 0, rightConstant: 0, widthConstant: 33, heightConstant: 0)
        }
    @objc func replyButtonTapped(){
        guard let comment = comment else { return }
        commentsVC?.handleReplyButton(with: comment)
    }
    @objc func likeButtonTapped(){
        guard let comment = comment else { return }
        if dislikeButton.isOn {
            dislikeButton.isOn = false
        }
        commentsVC?.handleVoteButton(with: comment, like: true)
    }
    @objc func dislikeButtonTapped(){
        guard let comment = comment else { return }
        if likeButton.isOn {
            likeButton.isOn = false
        }
        commentsVC?.handleVoteButton(with: comment, like: false)
    }
}











