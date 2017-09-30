//
//  MenuView.swift
//  Keddr
//
//  Created by macbook on 08.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class MenuView: CSImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        collection.register(MenuCell.self, forCellWithReuseIdentifier: "cellId")
        image = #imageLiteral(resourceName: "asus")
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init() {
        self.init(frame: .zero)
    }
    
    var navcon: UINavigationController?
    var mainVC: MainVC?
    var profileVC: ProfileVC?
    var currentVC: SlideOutViewController?
    
    let menuItems = [MenuItem(text: "Мой Профиль", image: #imageLiteral(resourceName: "user")), MenuItem(text: "Лента", image: #imageLiteral(resourceName: "lenta")), MenuItem(text: "Блоги", image: #imageLiteral(resourceName: "blogs")), MenuItem(text: "Сохраненное", image: #imageLiteral(resourceName: "saved")), MenuItem(text: "О Проекте", image: #imageLiteral(resourceName: "about")), MenuItem(text: "Настройки", image: #imageLiteral(resourceName: "settings")), MenuItem(text: "Выход", image: #imageLiteral(resourceName: "exit"))]
    
    let backgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()
    lazy var collection: UICollectionView = { [unowned self] _ in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.alwaysBounceVertical = true
        collection.delegate = self
        collection.dataSource = self
        return collection
    }(())
    func setupViews() {
        insertSubview(backgroundView, at: 0)
        addSubview(collection)
        
        backgroundView.fillSuperview()
        collection.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 60, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
}
//MARK: - UICollectionViewDelegate
extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let posts = mainVC?.posts, posts.count > 0 {
            mainVC?.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        switch indexPath.item {
        case 0:
            //profile
            if profileVC == nil{
                profileVC = ProfileVC(collectionViewLayout: StretchyHeaderLayout())
            }
            profileVC?.profileUrlString = "https://keddr.com/profile/"
            currentVC = profileVC
            navcon?.setViewControllers([profileVC!], animated: false)
        case 1:
            //posts
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.invalidateLayoutAndData()
            mainVC?.fetchPosts()
            currentVC = mainVC
            navcon?.setViewControllers([mainVC!], animated: false)
        case 2:
            //blogs
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.invalidateLayoutAndData()
            mainVC?.fetchBlogPosts()
            currentVC = mainVC
            navcon?.setViewControllers([mainVC!], animated: false)
        case 3:
            //saved posts
            mainVC?.invalidateLayoutAndData()
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.fetchSavedPosts()
            currentVC = mainVC
            navcon?.setViewControllers([mainVC!], animated: false)
        case 4:
            //about page
            ()
        case 5:
            //settings
            ()
        case 6:
            AuthClient.logOut()
            let loginVC = LoginVC()
            currentVC?.present(loginVC, animated: true)
        default:
            break
        }
        currentVC?.menuButtonTapped()
    }
}
//MARK: - UICollectionViewDataSource
extension MenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCell
        cell.menuItem = menuItems[indexPath.item]
        if indexPath.item == menuItems.count - 1 {
            cell.separatorLineView.alpha = 0
        }
        return cell
    }
}
extension MenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 20, height: 50)
    }
}


