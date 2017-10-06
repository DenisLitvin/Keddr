//
//  CSAlertView.swift
//  Keddr
//
//  Created by macbook on 06.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class CSAlertView {
    
    static let alertView: CSActivityView = {
        let view = CSActivityView()
        return view
    }()
    
    static func showAlert(with text: String, in view: UIView){
        DispatchQueue.main.async {
            if !view.subviews.contains(alertView){
                alertView.textLabel.text = text
                view.addSubview(self.alertView)
                alertView.anchorCenterSuperview()
                alertView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                alertView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                
                UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseOut, animations: {
                    alertView.transform = .identity
                    alertView.alpha = 1
                })
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseOut, animations: {
                    alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    alertView.alpha = 0
                }, completion: { _ in
                    alertView.removeFromSuperview()
                })
            })
            
        }
    }
    
}
