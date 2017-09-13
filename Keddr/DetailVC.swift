//
//  DetailVC.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class DetailVC: UICollectionViewController {
    
    unowned var context = appDelegate.persistentContainer.viewContext
    
    var feed: [FeedElement] = []
    
    var post: Post? {
        didSet{
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    func updateUI(){
        guard let post = post else { return }
        if let savedPost = post.findSavedPost(with: context) {
            let sortedFeed = savedPost.sortFeed()
            var feed = [FeedElement]()
            for element in sortedFeed{
                if let feedElement = FeedElement(savedFeedElement: element){
                    feed.append(feedElement)
                }
            }
            self.feed = feed
            self.collectionView?.reloadData()
            return
        }
        Api.fetchFeed(url: post.url!) { (feed) in
            self.feed = feed
            self.collectionView?.reloadData()
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = collectionView?.contentOffset.y
        let delta = min((offset! / (self.view.bounds.width * 9 / 16)), 1)
        navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: delta)
    }
    func setupCollectionView(){
        collectionView?.register(FeedHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(ParagraphCell.self, forCellWithReuseIdentifier: ElementType.p.rawValue)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: ElementType.video.rawValue)
        collectionView?.register(Header2Cell.self, forCellWithReuseIdentifier: ElementType.h2.rawValue)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: ElementType.image.rawValue)
        collectionView?.register(FotoramaCell.self, forCellWithReuseIdentifier: ElementType.fotorama.rawValue)
        collectionView?.register(TableCell.self, forCellWithReuseIdentifier: ElementType.table.rawValue)
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 44, right: 0)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    //MARK: - CollectionViewDelegate & CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = feed[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: content.type.rawValue, for: indexPath) as! FeedCell
        cell.post = post
        cell.content = content
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! FeedHeader
        view.content = post
        return view
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: (self.view.bounds.width * 9 / 16) + 70)
    }
}
//MARK: - CollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = feed[indexPath.item]
        var attributes: (name: String, size: CGFloat)
        let width = self.view.bounds.width
        let height: CGFloat
        if element.type == .fotorama || element.type == .video || element.type == .image {
            return CGSize(width: width, height: ((width) * 9 / 16))
        }
        if element.type == .h2 {
            attributes = (Font.title.name, Font.title.size)
        } else {
            attributes = (Font.description.name, Font.description.size)
        }
        height = calculateSize(for: [feed[indexPath.item].content], height: 9999, width: width - 30, positioning: .vertical, fontName: [attributes.name], fontSize: [attributes.size], removeIfNotFit: false).size.height
        return CGSize(width: width - 20, height: height + 13)
    }
}

