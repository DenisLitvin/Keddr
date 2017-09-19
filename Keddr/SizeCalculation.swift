//
//  SizeCalculation.swift
//  Keddr
//
//  Created by macbook on 12.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//
import UIKit

enum TextPositioning {
    case vertical
    case horizontal
}

class TextSize{
    class func calculate(for texts: [String], height: CGFloat, width: CGFloat, positioning: TextPositioning, fontName: [String], fontSize: [CGFloat], removeIfNotFit: Bool) -> (size: CGSize, quantity: Int){
        
        var attributes: [[String: Any]] = []
        
        let options: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        for index in 0..<texts.count{
            attributes.append([NSFontAttributeName: UIFont(name: fontName[index], size: fontSize[index])!, NSParagraphStyleAttributeName: NSParagraphStyle.default, NSForegroundColorAttributeName: UIColor.black])
        }
        var estimatedHeight: CGFloat = 0
        var estimatedWidth: CGFloat = 0
        
        var heightToUse: CGFloat
        var widthToUse: CGFloat
        var heightLeft = height
        var widthLeft = width
        
        switch positioning {
        case .vertical:
            heightToUse = removeIfNotFit ? 99999 : height
            widthToUse = width
            estimatedWidth = width
        case .horizontal:
            widthToUse = removeIfNotFit ? 99999 : width
            heightToUse = height
            estimatedHeight = height
        }
        for (num, text) in texts.enumerated(){
            let attribute = attributes[num]
            let rect = text.boundingRect(with: CGSize(width: widthToUse, height: heightToUse), options: options, attributes: attribute, context: nil)
            if positioning == TextPositioning.vertical {
                heightLeft -= rect.height
                heightToUse -= rect.height
                if heightLeft < 0 { return (CGSize(width: estimatedWidth, height: estimatedHeight), num) }
                estimatedHeight += rect.height
            }
            if positioning == TextPositioning.horizontal {
                widthLeft -= rect.width
                widthToUse -= rect.width
                if widthLeft < 0 { return (CGSize(width: estimatedWidth, height: estimatedHeight), num) }
                estimatedWidth += rect.width
            }
        }
        return (CGSize(width: estimatedWidth, height: estimatedHeight), texts.count)
    }
}
