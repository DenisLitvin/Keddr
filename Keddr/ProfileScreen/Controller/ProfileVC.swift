//
//  ProfileVC.swift
//  Keddr
//
//  Created by macbook on 27.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class ProfileVC: SlideOutCollectionViewController {
    
    var profileUrlString: String? {
        didSet{
            CSActivityIndicator.startAnimating(in: self.view)
            Api.fetchProfileInfo(with: profileUrlString!) { (posts, profile, error) in
                CSActivityIndicator.stopAnimating()
                if let error = error {
                    CSAlertView.showAlert(with: error.userDescription, in: self.view)
                } else if let posts = posts, let profile = profile{
                    self.posts = posts
                    self.profile = profile
                }
            }
        }
    }
    fileprivate var profile: Profile? { didSet { collectionView?.reloadData() } }
    fileprivate var posts: [Post] = [] { didSet { collectionView?.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        let layout = collectionView?.collectionViewLayout as! StretchyHeaderLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
}
//MARK: - UICollectionViewDataSource
extension ProfileVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProfileCell
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! ProfileHeader
            header.profile = profile
            return header
        }
        return UICollectionReusableView()
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let profile = profile else { return .zero}
        var size: CGSize = .zero
        if let commentCount = profile.commentCount,
            let onSiteTime = profile.onSiteTime,
            let postCount = profile.postCount,
            let userDevices = profile.userDevices {
            let text = commentCount + "\n" + onSiteTime + "\n" + postCount + "\n" + profile.description + "\n" + userDevices
            size = TextSize.calculate(for: [text], height: 99999, width: self.view.bounds.width - 20, positioning: .vertical, fontName: [Font.description.name], fontSize: [Font.description.size], removeIfNotFit: false).size
        }
        
        return CGSize(width: self.view.bounds.width, height: 150 + size.height + self.view.bounds.width * 9 / 16)
    }
}























