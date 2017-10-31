//
//  MainTarBarViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MainTarBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 去除 TabBar 上的横线
        tabBar.clipsToBounds = true
        
        tabBar.isTranslucent = false
        
        self.setViewControllers([HomeViewController(), ActivityViewController(),MineViewController()], animated: false)
        
        self.setCustomItem(title: "首页", image: #imageLiteral(resourceName: "tab_home"), selectedImage: #imageLiteral(resourceName: "tab_home"), index: 0)
        
        self.setCustomItem(title: "活动", image: #imageLiteral(resourceName: "tab_home"), selectedImage: #imageLiteral(resourceName: "tab_home"), index: 1)
        
        self.setCustomItem(title: "我的", image: #imageLiteral(resourceName: "tab_mine"), selectedImage: #imageLiteral(resourceName: "tab_mine"), index: 2)
        
        // 修改 TabBar 高亮图标的颜色
        tabBar.tintColor = #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.7843137255, alpha: 1)
    }
    
    private func setCustomItem(title:String?, image: UIImage?, selectedImage: UIImage?, index : Int){
        guard let image = image,let selectedImage = selectedImage else{
            return
        }
        let resizeImage = image.reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let resizeSelectedImage = selectedImage.reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let item = UITabBarItem(title: title, image: resizeImage, selectedImage: resizeSelectedImage)
        item.title = nil
        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        self.viewControllers?[index].tabBarItem = item
    }

}
