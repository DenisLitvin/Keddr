//
//  FotoramaCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class PhotoramaCell: PostDetailsBaseCell {
    
    var images: [PostElement] = []
    weak var delegate: ImageCellDelegate?
    
    lazy var collection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(collection)
        collection.fillSuperview()
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "cellId")
    }
    override func setupContent(with: PostElement) {
        super.setupContent(with: with)
        DispatchQueue.global().async {
            self.images = []
            for image in with.content.components(separatedBy: ","){
                let element = PostElement(type: .image, content: image)
                self.images.append(element)
            }
            DispatchQueue.main.async {
                self.collection.reloadData()
                self.collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            }
        }
    }
}
//MARK: - UICollectionViewDataSource
extension PhotoramaCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCell
        cell.delegate = delegate
        cell.post = post
        cell.content = images[indexPath.item]
        return cell
    }
}
//Mark: - UICollectionViewDelegateFlowLayout
extension PhotoramaCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 1.4, height: self.frame.height)
    }
}

