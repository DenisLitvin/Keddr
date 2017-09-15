//
//  CategorySlider.swift
//  Keddr
//
//  Created by macbook on 15.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CategorySlider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categories: [String] = [] {
        didSet{
            collection.reloadData()
        }
    }
    
    lazy var collection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        return view
        }()
    
    func setupViews(){
        addSubview(collection)
        collection.fillSuperview()
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
    }
}
//MARK: - UICollectionViewDataSource
extension CategorySlider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCell
        let text = categories[indexPath.item]
        cell.textView.text = text
        return cell
    }
}
//Mark: - UICollectionViewDelegateFlowLayout
extension CategorySlider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categories[indexPath.item]
        let size = TextSize.calculate(for: [text], height: 20, width: 9999, positioning: .horizontal, fontName: [Font.category.name], fontSize: [Font.category.size + 2], removeIfNotFit: false).size
        return CGSize(width: size.width + 5, height: self.frame.height)
    }
}










