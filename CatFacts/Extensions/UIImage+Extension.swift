//
//  UIImage+Extension.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/17.
//  Copyright © 2020 Pae. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func scaleToSize(_ sz:CGFloat) -> UIImage? {
        let ratio = sz / size.width
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageWithColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
