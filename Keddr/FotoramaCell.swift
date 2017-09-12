//
//  FotoramaCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class FotoramaCell: FeedCell {
    
    var images: [FeedElement] = []
    
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
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width * 9 / 16)
        layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.locations = [0.9, 1]
        self.layer.mask = layer
    }
    override func setupContent(with: FeedElement) {
        super.setupContent(with: with)
        images = []
        for image in with.content.components(separatedBy: ","){
            let element = FeedElement(type: .image, content: image)
            images.append(element)
        }
        self.collection.reloadData()
    }
}
//MARK: - UICollectionViewDataSource
extension FotoramaCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCell
        cell.post = post
        cell.content = images[indexPath.item]
        return cell
    }
}
//Mark: - UICollectionViewDelegateFlowLayout
extension FotoramaCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height, height: self.frame.height)
    }
}

