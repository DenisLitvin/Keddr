//
//  CommentCell.swift
//  Keddr
//
//  Created by macbook on 16.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CommentCell: BaseCell {
    
    var comment: Comment? {
        didSet{
            setupContent()
        }
    }
    
    var bubbleViewWidthConstraint: NSLayoutConstraint?
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightYellow
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    let textContainer: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = Color.lightYellow
        return view
    }()
    let dotArrayView: DotsView = {
        let view = DotsView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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
        //draw circles
        dotArrayView.numberOfDots = nestlevel
    }
    func updateText(date: String, authorName: String, description: String){
        let date = ("\(date)\n")
        let authorName = ("\(authorName)\n")
        let attributedText = NSMutableAttributedString(string: date, attributes: [NSForegroundColorAttributeName: Color.lightGray, NSFontAttributeName: Font.date.create()])
        attributedText.append(NSAttributedString(string: authorName, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: Font.title.create()]))
        attributedText.append(NSAttributedString(string: description, attributes: [NSForegroundColorAttributeName: Color.darkGray, NSFontAttributeName: Font.description.create()]))
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
        
        bubbleViewWidthConstraint = bubbleView.anchorWithReturnAnchors(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 10, heightConstant: 0)[3]
        textContainer.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        dotArrayView.anchor(top: avatarView.centerYAnchor, left: leftAnchor, bottom: nil, right: avatarView.rightAnchor, topConstant: -5, leftConstant: 3, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 10)
        avatarView.anchor(top: bubbleView.topAnchor, left: nil, bottom: nil, right: bubbleView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 50, heightConstant: 50)
        votesImageView.anchor(top: avatarView.bottomAnchor, left: nil, bottom: nil, right: avatarView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: -4, widthConstant: 30, heightConstant: 20)
        votesLabel.anchor(top: nil, left: avatarView.centerXAnchor, bottom: votesImageView.bottomAnchor, right: bubbleView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 14)
        
        }
}











