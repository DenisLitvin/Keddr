//
//  InputContainerView.swift
//  Keddr
//
//  Created by macbook on 06.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class InputContainerView: UIView {
    
    weak var delegate: CommentsVC?
    
    var parentComment: Comment?{
        didSet{
            updateReplyToCommentLabel()
        }
    }

    lazy var inputTextField: UITextView = { [weak self] in
        let view = UITextView()
        view.delegate = self
        view.font = Font.description.create()
        view.backgroundColor = Color.ultraLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var sendButton: UIButton = { [unowned self] in
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = Font.title.create()
        button.tintColor = Color.darkGray
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    var replyToCommentLabelHeightAnchor: NSLayoutConstraint?
    var replyToCommentLabelWidthAnchor: NSLayoutConstraint?
    let replyToCommentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Font.date.create()
        label.textColor = Color.ultraLightGray
        label.backgroundColor = Color.darkGray
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    lazy var cancelReplyingButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.tintColor = Color.ultraLightGray
        button.backgroundColor = Color.darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(cancelReplyingButtonTapped), for: .touchUpInside)
        //setimage
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(inputTextField)
        addSubview(sendButton)
        addSubview(replyToCommentLabel)
        addSubview(cancelReplyingButton)
        
        inputTextField.anchor(top: replyToCommentLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: sendButton.leftAnchor, topConstant: 3, leftConstant: 4, bottomConstant: 4, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        sendButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 5, widthConstant: 60, heightConstant: 33)
        let replyToCommentLabelAnchors = replyToCommentLabel.anchorWithReturnAnchors(top: topAnchor, left: inputTextField.leftAnchor, bottom: nil, right: nil, topConstant: 3, leftConstant: 3, bottomConstant: 0, rightConstant: 0, widthConstant: 1, heightConstant: 1)
        replyToCommentLabelWidthAnchor = replyToCommentLabelAnchors[2]
        replyToCommentLabelHeightAnchor = replyToCommentLabelAnchors[3]
        replyToCommentLabelHeightAnchor?.constant = 0
        replyToCommentLabelWidthAnchor?.constant = 0
        
        cancelReplyingButton.anchor(top: topAnchor, left: inputTextField.rightAnchor, bottom: nil, right: nil, topConstant: 3, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 0)
        cancelReplyingButton.heightAnchor.constraint(equalTo: replyToCommentLabel.heightAnchor, multiplier: 1).isActive = true
    }
    func updateReplyToCommentLabel(){
        if parentComment == nil {
            replyToCommentLabelHeightAnchor?.constant = 0
            changeInputContainerConstraint(for: inputTextField.text)
        }
        guard let author = parentComment?.authorName else { return }
        replyToCommentLabelWidthAnchor?.constant = TextSize.calculate(for: [author], height: 20, width: 300, positioning: .horizontal, fontName: [Font.date.name], fontSize: [Font.date.size], removeIfNotFit: false).size.width + 18
        replyToCommentLabel.text = author
        replyToCommentLabelHeightAnchor?.constant = 30
        changeInputContainerConstraint(for: inputTextField.text)
    }
    func changeInputContainerConstraint(for text: String){
        let height = TextSize.calculate(for: [text], height: 200, width: self.bounds.width - 85, positioning: .vertical, fontName: [Font.description.name], fontSize: [Font.description.size], removeIfNotFit: false).size.height
        delegate?.inputContainerViewHeightConstraint?.constant = height + 25 + (replyToCommentLabelHeightAnchor?.constant ?? 0)
    }
    @objc func cancelReplyingButtonTapped(){
        parentComment = nil
    }
    @objc func sendButtonTapped(){
        let parentId = (parentComment == nil) ? "0" : (parentComment?.commentId)!
        let comment = Comment()
        comment.content = inputTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        comment.parentId = parentId
        delegate?.handleSendButton(with: comment)
    }
}
extension InputContainerView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            changeInputContainerConstraint(for: text)
        }
    }
}
class CSInputTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 0, width: bounds.width - 20, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 0, width: bounds.width - 20, height: bounds.height)
    }
}
















