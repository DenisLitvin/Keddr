//
//  DetailVC.swift
//  Keddr
//
//  Created by macbook on 30.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class PostDetailsVC: UICollectionViewController {
    
    unowned var context = appDelegate.persistentContainer.viewContext
    
    weak var delegate: MainVC?
    
    var postElements: [PostElement] = []
    
    var post: Post? {
        didSet{
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePostBarButtonTapped))
    }
    @objc func savePostBarButtonTapped(){
        delegate?.handleSaveButton(with: post!, save: true)
        delegate?.collectionView?.reloadData()
        CSAlertView.showAlert(with: "Сохранено", in: self.view)
    }
    func updateUI(){
        guard let post = post else { return }
        CSActivityIndicator.startAnimating(in: self.view)
        if let savedPost = post.findSavedPost(with: context),
            let sortedFeed = savedPost.savedPostElements,
            sortedFeed.count > 0 {
            
            var postElement = [PostElement]()
            sortedFeed.forEach {
                if let feedElement = PostElement(savedFeedElement: $0 as! SavedPostElement ){
                    postElement.append(feedElement)
                }
            }
            self.postElements = postElement
            self.collectionView?.reloadData()
            CSActivityIndicator.stopAnimating()
            return
        }
        ApiManager.fetchPostElements(url: post.url!) { (feed) in
            CSActivityIndicator.stopAnimating()
            self.postElements = feed
            self.collectionView?.reloadData()
        }
    }
    func setupCollectionView(){
        collectionView?.register(PostDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(ParagraphCell.self, forCellWithReuseIdentifier: ElementType.p.rawValue)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: ElementType.video.rawValue)
        collectionView?.register(Header2Cell.self, forCellWithReuseIdentifier: ElementType.h2.rawValue)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: ElementType.image.rawValue)
        collectionView?.register(PhotoramaCell.self, forCellWithReuseIdentifier: ElementType.fotorama.rawValue)
        collectionView?.register(TableCell.self, forCellWithReuseIdentifier: ElementType.table.rawValue)
        collectionView?.backgroundColor = .white
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
    }
    func handleAuthorNameLabelTapped(){
        let profileVC = ProfileVC(collectionViewLayout: StretchyHeaderLayout())
        profileVC.profileUrlString = post?.postAuthorUrlString
        profileVC.navigationItem.leftBarButtonItems = []
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    //MARK: - CollectionViewDelegate & CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = postElements[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: content.type.rawValue, for: indexPath) as! PostDetailsBaseCell
        if let cell = cell as? ImageCell {
            cell.delegate = self
        }
        if let cell = cell as? PhotoramaCell {
            cell.delegate = self
        }
        cell.post = post
        cell.content = content
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postElements.count
    }
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! PostDetailsHeader
        view.delegate = self
        view.content = post
        return view
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: (self.view.bounds.width * 9 / 16) + 28)
    }
}
//MARK: - ImageCellDelegate
extension PostDetailsVC: ImageCellDelegate{
    func handleImageViewTap(with image: UIImage){
        let pictureDetailsVC = PictureDetailsVC()
        pictureDetailsVC.image = image
        navigationController?.pushViewController(pictureDetailsVC, animated: true)
    }
}
//MARK: - CollectionViewDelegateFlowLayout
extension PostDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = postElements[indexPath.item]
        var attributes: (name: String, size: CGFloat)
        let width = self.view.bounds.width
        let height: CGFloat
        if element.type == .fotorama || element.type == .video || element.type == .image {
            return CGSize(width: width - 20, height: ((width - 20) * 9 / 16))
        }
        if element.type == .h2 {
            attributes = (Font.title.name, Font.title.size)
        } else {
            attributes = (Font.description.name, Font.description.size)
        }
        height = TextSize.calculate(for: [postElements[indexPath.item].content], height: 9999, width: width - 30, positioning: .vertical, fontName: [attributes.name], fontSize: [attributes.size], removeIfNotFit: false).size.height
        return CGSize(width: width - 20, height: height + 18)
    }
}


