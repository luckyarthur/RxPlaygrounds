//
//  UIImage+Helpers.swift
//  RxPlaygrounds
//
//  Created by 杨弘宇 on 2016/9/18.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
    
    class func imageWithRoundRect(filled color: UIColor, radius: CGFloat) -> UIImage! {
        let scale = UIScreen.main.scale
        let size = CGSize(width: radius * 2, height: radius * 2)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setShouldAntialias(true)
        context.setFillColor(color.cgColor)
        context.addPath(CGPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerWidth: radius, cornerHeight: radius, transform: nil))
        context.fillPath()
        
        guard let cgImage = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: .up).resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius))
    }
    
}
