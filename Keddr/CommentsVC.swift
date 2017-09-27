//
//  CommentsVC.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CommentsVC: UICollectionViewController {
    
    var post: Post? { didSet{ fetchComments() } }
    var comments: [Comment] = [] { didSet{ collectionView?.reloadData() } }
    var bubbleViewSizes = [CGSize]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    func fetchComments(){
        guard let post = post else { return }
        Api.fetchComments(for: post) { (comments, postId) in
            //calculateSize
            let bubbleViewWidth = self.view.bounds.width - 65
            for comment in comments{
                guard let content = comment.content,
                let timeStamp = comment.timeStamp,
                let nestLevel = comment.nestLevel,
                let authorName = comment.authorName else { return }
                comment.postId = postId
                let widthForDots = CGFloat(nestLevel * 13)
                let textSize = TextSize.calculate(for: [timeStamp, authorName, content], height: 9999, width: bubbleViewWidth - widthForDots - 25, positioning: .vertical, fontName: [Font.date.name, Font.title.name, Font.description.name], fontSize: [Font.date.size, Font.title.size, Font.description.size], removeIfNotFit: false).size
                self.bubbleViewSizes.append(CGSize(width: bubbleViewWidth - widthForDots, height: textSize.height + 40))
            }
            self.comments = comments
        }
    }
    func setupCollectionView(){
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: "cellId")
    }
    //MARK: - Handling Events
    func handleVoteButton(with comment: Comment, like: Bool){
        AuthClient.voteComment(with: comment, like: like) { (error) in
            if let error = error {
                print(error.userDescription)
            } else {
//                comment.isLiked = like
                let vote = like ? "like" : "dislike"
                print("Successfuly voted with a", vote)
            }
        }
    }
    func handleReplyButton(with comment: Comment){
        AuthClient.reply(for: comment) { (error) in
            if let error = error {
                print(error.userDescription)
            } else {
                print("Successfuly commented:", comment)
            }
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

















