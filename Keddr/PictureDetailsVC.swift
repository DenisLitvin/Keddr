//
//  PictureDetailsVC.swift
//  Keddr
//
//  Created by macbook on 09.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class PictureDetailsVC: UIViewController {
    
    var image: UIImage?{
        didSet{
            imageView.image = image
            imageView.sizeToFit()
            setZoomParameters(for: scrollView.bounds.size)
            recenterImage()
        }
    }
    lazy var scrollView: UIScrollView = { [unowned self] in
        let view = UIScrollView(frame: self.view.bounds)
        view.backgroundColor = .white
        view.delegate = self
        return view
        }()
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setZoomParameters(for: scrollView.bounds.size)
        recenterImage()
    }
    
    override func viewWillLayoutSubviews() {
        setZoomParameters(for: scrollView.bounds.size)
        recenterImage()
    }
    
    func setupViews(){
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    func recenterImage(){
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let horizontalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
    func setZoomParameters(for scrollViewSize: CGSize) {
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = minScale
        
    }
}
extension PictureDetailsVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}















