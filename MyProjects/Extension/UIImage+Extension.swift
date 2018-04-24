//
//  UIImage+Ex.swift
//  finding
//
//  Created by bob song on 16/12/7.
//  Copyright © 2016年 fxdz. All rights reserved.
//

import UIKit

extension UIImage {
    //根据传进来的颜色创建一张图片
    static func imageWithColor(_ color : UIColor) ->UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
    func resized(newWidth: CGFloat = 500) -> UIImage
    {
        if newWidth >= self.size.width{
            return self
        }
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
