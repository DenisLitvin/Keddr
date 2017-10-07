//
//  CommentsVC.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CommentsVC: UICollectionViewController {
    
    var postId: String?
    var post: Post? { didSet{ fetchComments() } }
    var comments: [Comment] = [] { didSet{ collectionView?.reloadData() } }
    var bubbleViewSizes = [CGSize]()
    
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    var inputContainerViewBottomConstraint: NSLayoutConstraint?
    lazy var inputContainerView: InputContainerView = { [unowned self] in
        let view = InputContainerView()
        view.delegate = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
        setupNotifications()
    }
    func fetchComments(){
        guard let post = post else { return }
        CSActivityIndicator.startAnimating(in: self.view)
        ApiManager.fetchComments(for: post) { (comments, postId) in
            CSActivityIndicator.stopAnimating()
            let bubbleViewWidth = self.view.bounds.width - 65
            for comment in comments{
                guard let content = comment.content,
                let timeStamp = comment.timeStamp,
                let nestLevel = comment.nestLevel,
                let authorName = comment.authorName else { return }
                comment.postId = postId
                self.postId = postId
                let widthForDots = CGFloat(nestLevel * 13)
                let textSize = TextSize.calculate(for: [timeStamp, authorName, content], height: 9999, width: bubbleViewWidth - widthForDots - 25, positioning: .vertical, fontName: [Font.date.name, Font.title.name, Font.description.name], fontSize: [Font.date.size, Font.title.size, Font.description.size], removeIfNotFit: false).size
                self.bubbleViewSizes.append(CGSize(width: bubbleViewWidth - widthForDots, height: textSize.height + 40))
            }
            self.comments = comments
        }
    }
    func setupCollectionView(){
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: "cellId")
    }
    func setupViews(){
        view.addSubview(inputContainerView)
        
        let inputContainerViewAnchors = inputContainerView.anchorWithReturnAnchors(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        inputContainerViewBottomConstraint = inputContainerViewAnchors[1]
        inputContainerViewHeightConstraint = inputContainerViewAnchors[3]
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK: - Handling Events
    func handleVoteButton(with comment: Comment, like: Bool){
        AuthClient.voteComment(with: comment, like: like) { (error) in
            if let error = error {
                CSAlertView.showAlert(with: error.userDescription, in: self.view)
            } else {
                let vote = like ? "like" : "dislike"
                print("Successfuly voted with a", vote)
            }
        }
    }
    func handleReplyButton(with comment: Comment){
        inputContainerView.parentComment = comment
    }
    func handleSendButton(with comment: Comment){
        comment.postId = postId
        AuthClient.reply(with: comment) { (error) in
            if let error = error {
                CSAlertView.showAlert(with: error.userDescription, in: self.view)
            } else {
                self.fetchComments()
                print("Successfuly commented with:", comment)
            }
        }
    }
    @objc func handleKeyboardNotifications(_ notification: Notification){
        guard let info = notification.userInfo else { return }
        if let endRect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let beginRect = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            //showed up
            if endRect.origin.y - beginRect.origin.y > 100{
                inputContainerViewBottomConstraint?.constant = 0
            } else {
                inputContainerViewBottomConstraint?.constant = -endRect.height
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

}
//MARK: - UICollectionViewDataSource
extension CommentsVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        let size = bubbleViewSizes[indexPath.item]
        cell.commentsVC = self
        cell.bubbleViewWidthConstraint?.constant = size.width
        cell.comment = comment
        return cell
    }
    
}
//Mark: - UICollectionViewDelegateFlowLayout
extension CommentsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = bubbleViewSizes[indexPath.item]
        return CGSize(width: self.view.bounds.width, height: size.height)
    }
}

















