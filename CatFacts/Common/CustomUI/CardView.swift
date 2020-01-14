//
//  CardView.swift
//  Alaitisal
//
//  Created by Alex on 2019/7/22.
//  Copyright © 2019 JN. All rights reserved.
//
import UIKit
@IBDesignable
class CardView: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = .black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

