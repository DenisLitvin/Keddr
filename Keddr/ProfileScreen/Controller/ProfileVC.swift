//
//  ProfileVC.swift
//  Keddr
//
//  Created by macbook on 27.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ProfileVC: UICollectionViewController {
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        let layout = collectionView?.collectionViewLayout as! StretchyHeaderLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: "cellId")
    }
}
//MARK: - UICollectionViewDataSource
extension ProfileVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProfileCell
//        let comment = comments[indexPath.item]
//        let size = bubbleViewSizes[indexPath.item]
//        cell.commentsVC = self
//        cell.bubbleViewWidthConstraint?.constant = size.width
//        cell.comment = comment
        return cell
    }
    
}
//Mark: - UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 40)
    }
}






















