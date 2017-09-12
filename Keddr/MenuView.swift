//
//  MenuView.swift
//  Keddr
//
//  Created by macbook on 08.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class MenuView: UIVisualEffectView {
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        collection.register(MenuCell.self, forCellWithReuseIdentifier: "cellId")
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(){
        self.init(effect: UIBlurEffect(style: .dark))
    }
    weak var delegate: MainVC?
    
    let menu = ["Лента", "Блоги", "О проекте"]
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("back", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    lazy var collection: UICollectionView = { [unowned self] _ in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    func setupViews(){
        contentView.addSubview(dismissButton)
        contentView.addSubview(collection)
        
        collection.anchor(top: centerYAnchor, left: centerXAnchor, bottom: nil, right: nil, topConstant: -65, leftConstant: -100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 130)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
        })
    }
}
//MARK: - UICollectionViewDelegate
extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.fetchSavedPosts()
    }
}
//MARK: - UICollectionViewDataSource
extension MenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCell
        cell.textView.text = menu[indexPath.item]
        return cell
    }
}
extension MenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 40)
    }
}

