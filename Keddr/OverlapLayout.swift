//
//  OverlapLayout.swift
//  Keddr
//
//  Created by macbook on 13.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class OverlapLayout: UICollectionViewFlowLayout {
    
    var isSetup = false
    
    override func prepare() {
        super.prepare()
        if isSetup == false {
            setupCollectionView()
            isSetup = true
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for itemAttributes in attributes! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            changeLayoutAttributes(itemAttributesCopy)
            attributesCopy.append(itemAttributesCopy)
        }
        return attributesCopy
    }
    func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes){
        attributes.zIndex = attributes.indexPath.item
    }
    func setupCollectionView(){
        
    }
}




