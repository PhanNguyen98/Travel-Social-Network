//
//  UIView+SetBackgroundImage.swift
//  Travel Social
//
//  Created by Phan Nguyen on 28/01/2021.
//

import UIKit

extension UIView{

    func setBackgroundImage(img: UIImage){
        UIGraphicsBeginImageContext(self.frame.size)
        img.draw(in: self.bounds)
        let patternImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor(patternImage: patternImage)
    }
}
