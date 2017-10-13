//
//  MainVC.swift
//  Keddr
//
//  Created by macbook on 22.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import Kanna
import CoreData
import KeychainAccess

class MainVC: SlideOutCollectionViewController {
    
    fileprivate let cellId = "cellId"
    var posts: [Post] = [] {
        didSet{
            self.collectionView?.reloadData()
            self.collectionViewLayout.invalidateLayout()
        }
    }
    var contentController = ContentController()
    var textSizes: [(title: CGSize, description: CGSize)] = []
    var itemHeights: [CGFloat] = []
    
    let keychain = Keychain(service: "com.keddr.credentials")
    
    unowned var menuView = appDelegate.menuView
    unowned var container = appDelegate.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        fetchPosts()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.isSimplifiedLayout(), collectionView?.collectionViewLayout is UltraVisualLayout{
            changelayout(to: OverlapLayout())
        } else if !UserDefaults.standard.isSimplifiedLayout(), collectionView?.collectionViewLayout is OverlapLayout{
            changelayout(to: UltraVisualLayout())
        }
        if !UserDefaults.standard.isLoginScreenShown(){
            let loginVC = LoginVC()
            self.present(loginVC, animated: false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let maxOffset = (collectionView?.contentSize.height)! - view.bounds.height - 180
        let currentOffset = collectionView?.contentOffset.y
        if currentOffset! > maxOffset,
        contentController.loadingPageNumber == contentController.numberOfPagesLoaded,
        contentController.autoFetching{
            if title == "Блоги"{
                fetchBlogPosts()
            } else if title == "Лента"{
                fetchPosts()
            }
        }
    }
    //MARK: - Fetching posts
    func fetchPosts(){
        contentController.autoFetching = true
        contentController.requestedPosts = true
        contentController.loadingPageNumber += 1
        CSActivityIndicator.startAnimating(in: self.view)
        ApiManager.fetchPosts(for: contentController.loadingPageNumber, complition: { (posts) in
            CSActivityIndicator.stopAnimating()
            if self.contentController.requestedPosts{
                for post in posts{
                    self.setupCaclulations(for: post, layout: self.collectionView!.collectionViewLayout)
                }
                self.posts.append(contentsOf: posts)
                self.contentController.numberOfPagesLoaded += 1
            }
        })
    }
    func fetchBlogPosts(){
        contentController.autoFetching = true
        contentController.requestedPosts = false
        contentController.loadingPageNumber += 1
        CSActivityIndicator.startAnimating(in: self.view)
        ApiManager.fetchBlogPosts(for: contentController.loadingPageNumber, complition: { (posts) in
            CSActivityIndicator.stopAnimating()
            if !self.contentController.requestedPosts{
                for post in posts{
                    self.setupCaclulations(for: post, layout: self.collectionView!.collectionViewLayout)
                }
                self.posts.append(contentsOf: posts)
                self.contentController.numberOfPagesLoaded += 1
            }
        })
    }
    func fetchSavedPosts(){
        contentController.autoFetching = false
        CSActivityIndicator.startAnimating(in: self.view)
        let request: NSFetchRequest<SavedPost> = SavedPost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do{
            let results = try container.viewContext.fetch(request)
            var posts = [Post]()
            CSActivityIndicator.stopAnimating()
            for post in results {
                if let post = Post(savedPost: post){
                    self.setupCaclulations(for: post, layout: self.collectionView!.collectionViewLayout)
                    posts.append(post)
                }
                self.posts = posts
            }
        } catch {
            print("Failed to fetch saved posts, error:", error)
        }
    }
    //MARK: - Handling events
    
    func handleSaveButton(with post: Post, save: Bool){
        guard let url = post.url else { return }
        self.container.performBackgroundTask { (context) in
            let savedPost = post.findSavedPost(with: context)
            if !save, let savedPost = savedPost {
                context.delete(savedPost)
                SavedImage.deleteImages(for: url)
                try? context.save()
            } else if savedPost == nil {
                ApiManager.fetchPostElements(url: url) { (elements) in
                    post.createSavedPost(with: context, feedElements: elements)
                    try? context.save()
                }
            }
        }
    }
    func changelayout(to layout: UICollectionViewLayout) {
        if let layout = layout as? UltraVisualLayout{
            collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
            for post in posts{
                setupCaclulations(for: post, layout: layout)
            }
        } else if layout is OverlapLayout {
            collectionView?.decelerationRate = UIScrollViewDecelerationRateNormal
        }
        collectionView?.reloadData()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.setCollectionViewLayout(layout, animated: false)
    }
}
extension MainVC {
    //MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell 
        let post = posts[indexPath.item]
        let size = textSizes[indexPath.item]
        cell.mainVC = self
        cell.titleHeightConstraint?.constant = size.title.height + 20
        cell.descriptionHeightConstraint?.constant = size.description.height + 20
        cell.post = post
        return cell
    }
    //MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let detailVC = PostDetailsVC(collectionViewLayout: StretchyHeaderLayout())
        detailVC.post = post
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: itemHeights[indexPath.item])
    }
}
//MARK: - Helpers
extension MainVC {
    func invalidateLayoutAndData(){
        contentController.clear()
        posts = []
        textSizes = []
        itemHeights = []
        if let layout = collectionView?.collectionViewLayout as? UltraVisualLayout{
            layout.itemHeights = []
            layout.dragOffsets = []
        }
        collectionView?.reloadData()
        collectionViewLayout.invalidateLayout()
    }
    func setupCaclulations(for post: Post, layout: UICollectionViewLayout){
        let textSize = self.textSizeForPost(post)
        self.textSizes.append(textSize)
        let itemHeight = textSize.0.height + textSize.1.height + (self.view.bounds.width * 9 / 16) + 43
        self.itemHeights.append(itemHeight)
        if let layout = layout as? UltraVisualLayout {
            layout.addItemHeight(height: itemHeight)
        }
    }
    func textSizeForPost(_ post: Post) -> (CGSize, CGSize){
        if let title = post.title, let description = post.description {
            let screenWidth = self.view.frame.width
            let screenHeight = self.view.frame.height
            let height: CGFloat = screenHeight - (screenWidth * 9 / 16) - 93 - 30
            let width: CGFloat = screenWidth - 20
            let titleSize = TextSize.calculate(for: [title], height: height, width: width, positioning: .vertical, fontName: [Font.title.name], fontSize: [Font.title.size], removeIfNotFit: false).size
            let descriptionSize = TextSize.calculate(for: [description], height: height - titleSize.height - 20, width: width, positioning: .vertical, fontName: [Font.description.name], fontSize: [Font.description.size], removeIfNotFit: false).size
            return (CGSize(width: width, height: titleSize.height), CGSize(width: width, height: descriptionSize.height))
        }
        return (.zero, .zero)
    }
}

//MARK: - Prefetching
//extension MainVC: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        DispatchQueue.global().async {
//                        for indexPath in indexPaths{
//                            DispatchQueue.main.async {
//                                let imageView = CustomImageView()
//                                imageView.loadImageUsingUrlString(self.posts![indexPath.item].thumbnailImageUrl!)
//                            }
//                        }
//        }
//    }
//}










