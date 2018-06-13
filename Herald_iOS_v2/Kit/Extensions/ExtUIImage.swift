//
//  ExtUIImage.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

extension UIImage {
    /// 重设图片大小
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContext(reSize)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
}

