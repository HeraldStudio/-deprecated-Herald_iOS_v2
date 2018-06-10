//
//  MainTabBarController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainTabBarController: UITabBarController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化基界面
        self.view.tintColor = HeraldColorHelper.GeneralColor.White
        self.view.backgroundColor = HeraldColorHelper.GeneralColor.White
        setNavigationBar()
        
        // 去除 TabBar 上的横线
        tabBar.clipsToBounds = true
        
        tabBar.isTranslucent = false
        
        // 修改 TabBar 高亮图标的颜色
        tabBar.tintColor = HeraldColorHelper.HintColor.PrimaryLt
    }
    
    func getHeight() -> CGFloat{
        return tabBar.frame.height
    }
    
    func getWidth() -> CGFloat{
        return tabBar.frame.width
    }
    
    func setTab() {
        self.setViewControllers([HomeViewController(),ActivityViewController(),NoticeViewController()], animated: false)
        
        self.setCustomItem(title: "首页", image: #imageLiteral(resourceName: "tab-home"), selectedImage: #imageLiteral(resourceName: "tab-home-selected"), index: 0)
        
        self.setCustomItem(title: "活动", image: #imageLiteral(resourceName: "tab-discover"), selectedImage: #imageLiteral(resourceName: "tab-discover-selected"), index: 1)
        
        self.setCustomItem(title: "通知", image: #imageLiteral(resourceName: "tab-notice"), selectedImage: #imageLiteral(resourceName: "tab-notice-selected"), index: 2)
    }
    
    private func setCustomItem(title:String?, image: UIImage?, selectedImage: UIImage?, index : Int){
        guard let image = image,let selectedImage = selectedImage else {
            return
        }
        let resizeImage = image.reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let resizeSelectedImage = selectedImage.reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let item = UITabBarItem(title: title, image: resizeImage, selectedImage: resizeSelectedImage)
        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        self.viewControllers?[index].tabBarItem = item
    }
    
    private func setNavigationBar() {
        
        // 自定义返回按钮
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        backBarButton.tintColor = HeraldColorHelper.HintColor.PrimaryLt
        
        let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        let title = "小猴偷米"
        let attibutesTitle = NSMutableAttributedString.init(string: title)
        let length = (title as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        attibutesTitle.addAttributes(TextAttributesHelper.titleTextAttributes, range: titleRange)
        titleButton.setAttributedTitle(attibutesTitle, for: .normal)
        
        self.navigationItem.backBarButtonItem = backBarButton
        self.navigationItem.titleView = titleButton
    }
    
    @objc func presentLoginVC() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
