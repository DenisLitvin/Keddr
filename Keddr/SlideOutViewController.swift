//
//  SlideOutController.swift
//  Keddr
//
//  Created by macbook on 28.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class SlideOutViewController: UICollectionViewController{
    
    func menuButtonTapped(){
        if self.navigationController?.view.transform == .identity {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.view.transform = CGAffineTransform(translationX: self.view.bounds.width * 0.8, y: 0)
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.navigationController?.view.transform  = .identity
            })
        }
    }
}

















