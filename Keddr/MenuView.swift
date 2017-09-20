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
    
    weak var mainVC: MainVC?
    let menu = ["Лента", "Блоги", "Сохраненное", "О проекте"]
    
    lazy var dismissButton: UIButton = { [unowned self] _ in
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("back", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
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
        
        collection.anchor(top: centerYAnchor, left: centerXAnchor, bottom: nil, right: nil, topConstant: -(CGFloat(menu.count * 40) / 2), leftConstant: -100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: CGFloat(menu.count * 40))
        dismissButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    func menuButtonTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            self.effect = UIBlurEffect(style: .dark)
        })
    }
    func dismissButtonTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.effect = nil
            self.transform = CGAffineTransform(translationX: -(self.superview?.bounds.width)!, y: 0)
        })
    }
}
//MARK: - UICollectionViewDelegate
extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let posts = mainVC?.posts, posts.count > 0 {
            mainVC?.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        mainVC?.invalidateLayoutAndData()
        if indexPath.item == 2 {
            mainVC?.fetchSavedPosts()
            self.dismissButtonTapped()
            return
        }
        mainVC?.fetchPosts()
        self.dismissButtonTapped()
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


