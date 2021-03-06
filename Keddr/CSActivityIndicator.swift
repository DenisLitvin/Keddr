//
//  CSActivityIndicator.swift
//  Keddr
//
//  Created by macbook on 30.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSActivityIndicator {
    
    static private let blurView: CSActivityView = {
        let view = CSActivityView()
        createAnimation(in: view.vibrancyView.contentView.layer, layerSize: CGSize(width: 100, height: 100), animationSize: CGSize(width: 50, height: 50), color: Color.keddrYellow)
        return view
    }()
    static func startAnimating(in view: UIView){
        DispatchQueue.main.async {
            if !view.subviews.contains(blurView){
                view.addSubview(self.blurView)
                blurView.anchorCenterSuperview()
                blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                blurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                blurView.transform = .identity
                blurView.alpha = 1
            })
        }
    }
    static func stopAnimating(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                blurView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                blurView.alpha = 0
            }, completion: { _ in
                blurView.removeFromSuperview()
            })
        }
    }
    static private func createAnimationShape(with size: CGSize, color: UIColor) -> CAShapeLayer{
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let shapePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: size.width / 2)
        shapeLayer.fillColor = color.cgColor
        shapeLayer.backgroundColor = nil
        shapeLayer.path = shapePath.cgPath
        return shapeLayer
    }
    static private func createAnimation(in layer: CALayer, layerSize: CGSize, animationSize: CGSize, color: UIColor) {
        
        let lineSize = animationSize.width / 9
        let x: CGFloat = (layerSize.width - animationSize.width) / 2
        let y: CGFloat = (layerSize.height - animationSize.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.4, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        for i in 0 ..< 5 {
            
            let line = createAnimationShape(with: CGSize(width: lineSize, height: animationSize.height), color: color)
            line.frame = CGRect(x: x + lineSize * 2 * CGFloat(i), y: y, width: lineSize, height: animationSize.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}

















