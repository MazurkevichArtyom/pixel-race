//
//  UIView+Utilities.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 12.02.2022.
//

import Foundation
import UIKit

extension UIView {
    func applyCornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func applyShadow(offset: CGSize, radius: CGFloat, color: UIColor = UIColor.black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
