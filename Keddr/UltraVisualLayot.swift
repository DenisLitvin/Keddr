//
//  CustomLayot.swift
//  Keddr
//
//  Created by macbook on 27.07.17.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class UltraVisualLayout: UICollectionViewLayout{
    
    fileprivate var dragOffsets = [CGFloat]()
    var itemHeights = [CGFloat]()
    var standartHeight: CGFloat {
        get{
            return (collectionView?.bounds.width)! / 4
        }
    }
    func addItemheight(height: CGFloat){
        itemHeights.append(height)
        let dragOffset = height + (dragOffsets.last ?? 0)
        dragOffsets.append(dragOffset)
    }
    fileprivate func searchForItemIndexByOffset(_ offset: CGFloat) -> Int{
        for (index, off) in dragOffsets.enumerated(){
            if off > offset{
                return index
            }
        }
        return numberOfItems - 1
    }
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var yContentOffset: CGFloat{
        get{
            return (collectionView?.contentOffset.y)!
        }
    }
    fileprivate var featuredItemIndex: Int{
        get{
            return max(0, searchForItemIndexByOffset(yContentOffset))
        }
    }
    fileprivate var nextItemPercentageOffset: CGFloat{
        get{
            let index = featuredItemIndex
            let itemOffset = dragOffsets[index]
            return 1 - ((itemOffset - yContentOffset) / itemHeights[index])
        }
    }
    fileprivate var width: CGFloat{
        get{
            return collectionView!.bounds.width
        }
    }
    fileprivate var height: CGFloat{
        get{
            return collectionView!.bounds.height
        }
    }
    fileprivate var numberOfItems: Int{
        get{
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    //MARK: UICollectionViewLayout
    
    override var collectionViewContentSize: CGSize{
        get{
            var contentHeight: CGFloat = 0
            if let offset = dragOffsets.last{
                contentHeight = offset + 400
            }
            return CGSize(width: width, height: contentHeight)
        }
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems{
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            var height = standartHeight
            let nextItemPercentageOff = nextItemPercentageOffset

            if indexPath.item == featuredItemIndex{
                let yOffset = standartHeight * nextItemPercentageOff
                y = yContentOffset - yOffset + standartHeight
                height = itemHeights[indexPath.item]
                
            } else if (indexPath.item == featuredItemIndex + 1), indexPath.item < numberOfItems {
                let maxY = y + standartHeight
                height = standartHeight + max((itemHeights[indexPath.item] - standartHeight) * nextItemPercentageOff, 0)
                y = maxY - (standartHeight + max((itemHeights[indexPath.item - 1] - standartHeight) * nextItemPercentageOff, 0))
            } else if indexPath.item == featuredItemIndex - 1, indexPath.item >= 0{
                y = yContentOffset - (standartHeight * nextItemPercentageOff)
            }
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = attributes.frame.maxY
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache{
            if attributes.frame.intersects(rect){
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = searchForItemIndexByOffset(proposedContentOffset.y)
        var yOffset = dragOffsets[itemIndex]
        
        if itemIndex == 0 && dragOffsets[itemIndex] - proposedContentOffset.y > proposedContentOffset.y{
            yOffset = 0
        }
        if itemIndex != 0 && dragOffsets[itemIndex] - proposedContentOffset.y > proposedContentOffset.y - dragOffsets[itemIndex - 1]{
            yOffset = dragOffsets[itemIndex - 1]
        }
        return CGPoint(x: 0, y: yOffset)
    }
    
}



