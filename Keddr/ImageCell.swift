//
//  ImageCell.swift
//  Keddr
//
//  Created by macbook on 31.08.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: class {
    func handleImageViewTap(with image: UIImage)
}

class ImageCell: PostDetailsBaseCell {
    
    weak var delegate: ImageCellDelegate?
    
    lazy var imageView: CSImageView = { [unowned self] in
        let view = CSImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 7
        view.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        view.addGestureRecognizer(gr)
        return view
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 5, bottomConstant: 3, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    override func setupContent(with: PostElement) {
        super.setupContent(with: with)
        imageView.loadImageUsingUrlString(with.content, directoryPathUrl: (post?.url)!)
    }
    @objc func imageViewTapped(){
        guard let image = imageView.image else { return }
        delegate?.handleImageViewTap(with: image)
    }
}
