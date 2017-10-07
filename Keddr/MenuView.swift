//
//  MenuView.swift
//  Keddr
//
//  Created by macbook on 08.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    init() {
        super.init(frame: .zero)
        collection.register(MenuCell.self, forCellWithReuseIdentifier: "cellId")
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var navcon: UINavigationController?
    var mainVC: MainVC?
    var profileVC: ProfileVC?
    var settingsVC: SettingsVC?
    var currentVC: UIViewController?
    
    let menuItems = [MenuItem(text: "Мой Профиль", iconType: MenuIconType.profile), MenuItem(text: "Лента", iconType: MenuIconType.tape), MenuItem(text: "Блоги", iconType: MenuIconType.blogs), MenuItem(text: "Сохраненное", iconType: MenuIconType.saved), MenuItem(text: "Настройки", iconType: MenuIconType.settings), MenuItem(text: "Выход", iconType: MenuIconType.signOut)]
    
    lazy var collection: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = Color.ultraLightGray
        collection.alwaysBounceVertical = true
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: -70, right: 0)
        collection.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
        return collection
        }()
    func setupViews() {
        addSubview(collection)
        
        collection.fillSuperview()
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
        case 1:
            //posts
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.invalidateLayoutAndData()
            mainVC?.fetchPosts()
            currentVC = mainVC
        case 2:
            //blogs
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.invalidateLayoutAndData()
            mainVC?.fetchBlogPosts()
            currentVC = mainVC
        case 3:
            //saved posts
            mainVC?.invalidateLayoutAndData()
            if mainVC == nil{
                mainVC = MainVC(collectionViewLayout: OverlapLayout())
            }
            mainVC?.fetchSavedPosts()
            currentVC = mainVC
        case 4:
            //settings
            if settingsVC == nil{
                settingsVC = SettingsVC(style: .grouped)
            }
            currentVC = settingsVC
        case 5:
            AuthClient.signOut()
            let loginVC = LoginVC()
            currentVC?.present(loginVC, animated: true)
        default:
            break
        }
        navcon?.setViewControllers([currentVC!], animated: false)
        if indexPath.item != 5 {
            currentVC?.title = menuItems[indexPath.item].text
        }
        if let currentVC = currentVC as? SlideOutViewControlling {
            currentVC.menuButtonTapped()
        }
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
        return CGSize(width: self.bounds.width, height: 50)
    }
}


