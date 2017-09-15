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

class MainVC: UICollectionViewController {
    
    fileprivate let cellId = "cellId"
    var posts: [Post] = []
    var pageStatistics = PageStatistics()
    var textSizes: [CGSize] = []
    var itemHeights: [CGFloat] = []
    
    unowned var menuView = appDelegate.menuView
    unowned var container = appDelegate.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(handleMenuTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Statistics", style: .plain, target: self, action: #selector(printDatabaseStatistics))
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        fetchPosts()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //            for cell in (collectionView?.visibleCells) as! [PostCell]{
        //                let index = collectionView?.indexPath(for: cell)?.item
        //                cell.animateViews(num: Double(index!))
        //            }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //                        let maxOffset = (collectionView?.contentSize.height)! - view.bounds.height - 1100
        //                        let currentOffset = collectionView?.contentOffset.y
        //                        if currentOffset! > maxOffset && updatingPageNumber == numberOfFetches{
        //                            fetchNextPosts()
        //                            collectionView?.reloadData()
        //                        }
    }
    //MARK: - Fetching posts
    func fetchPosts(){
        pageStatistics.loadingPageNumber += 1
        Api.fetchPosts(for: pageStatistics.loadingPageNumber, complition: { (posts) in
            for post in posts{
                self.setupCaclulations(for: post, layout: self.collectionView!.collectionViewLayout)
            }
            self.posts.append(contentsOf: posts)
            self.pageStatistics.numberOfPagesLoaded += 1
            self.collectionView?.reloadData()
            self.collectionViewLayout.invalidateLayout()
            Api.fetchComments(for: posts[0]) { (comments) in
                
            }
        })
    }
    func fetchSavedPosts(){
        let request: NSFetchRequest<SavedPost> = SavedPost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do{
            let results = try container.viewContext.fetch(request)
            var posts = [Post]()
            for post in results {
                if let post = Post(savedPost: post){
                    self.setupCaclulations(for: post, layout: self.collectionView!.collectionViewLayout)
                    posts.append(post)
                }
                self.posts = posts
                self.collectionView?.reloadData()
                self.collectionViewLayout.invalidateLayout()
            }
        } catch {
            //handle error
        }
    }
    //MARK: - Handling events
    func handleMenuTapped(){
        menuView.slideIn()
    }
    func changelayout() {
        var layout = UICollectionViewLayout()
        if self.collectionView?.collectionViewLayout is OverlapLayout {
            layout = UltraVisualLayout()
            collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -300, right: 0)
            for post in posts{
                setupCaclulations(for: post, layout: layout)
            }
        } else if self.collectionView?.collectionViewLayout is UltraVisualLayout {
            layout = OverlapLayout()
            collectionView?.decelerationRate = UIScrollViewDecelerationRateNormal
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        collectionView?.reloadData()
        collectionViewLayout.invalidateLayout()
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    //MARK: - Persistence
    func printDatabaseStatistics() {
        let context = container.viewContext
        context.perform {
            if Thread.isMainThread {
                print("on main thread")
            } else {
                print("off main thread")
            }
            if let postCount = try? context.count(for: SavedPost.fetchRequest()) {
                print("\(postCount) Posts")
            }
            if let feedCount = try? context.count(for: SavedFeedElement.fetchRequest()) {
                print("\(feedCount) FeedElements")
            }
        }
        changelayout()
    }
}
extension MainVC: PostCellDelegate {
    func handleSaveTapped(with post: Post, save: Bool){
        guard let url = post.url else { return }
        self.container.performBackgroundTask { (context) in
            let savedPost = post.findSavedPost(with: context)
            if !save, let savedPost = savedPost {
                context.delete(savedPost)
                SavedImage.deleteImages(for: url)
                try? context.save()
            } else if savedPost == nil {
                Api.fetchFeed(url: url) { (elements) in
                    post.createSavedPost(with: context, feedElements: elements)
                    try? context.save()
                }
            }
        }
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
        cell.delegate = self
        cell.textContainer.frame = CGRect(x: 8, y: 0, width: size.width + 9, height: size.height + 24)
        cell.post = post
        return cell
    }
    //MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let detailVC = DetailVC(collectionViewLayout: StretchyHeaderLayout())
        detailVC.post = post
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
        pageStatistics.clear()
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
        let itemHeight = textSize.height + (self.view.bounds.width * 9 / 16) + 43
        self.textSizes.append(textSize)
        self.itemHeights.append(itemHeight)
        if let layout = layout as? UltraVisualLayout {
            layout.addItemheight(height: itemHeight)
        }
    }
    func textSizeForPost(_ post: Post) -> CGSize {
        if let title = post.title, let description = post.description {
            let screenWidth = self.view.bounds.width
            let screenHeight = self.view.bounds.height
            let height: CGFloat = screenHeight - (screenWidth * 9 / 16) - 93 - 50
            let width: CGFloat = screenWidth - 25
            let textSize = calculateSize(for: [title, description], height: height, width: width, positioning: .vertical, fontName: [Font.title.name, Font.description.name], fontSize: [Font.title.size, Font.description.size], removeIfNotFit: false).size
            return CGSize(width: width, height: textSize.height)
        }
        return CGSize.zero
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










