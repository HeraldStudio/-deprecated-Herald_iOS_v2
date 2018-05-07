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
        self.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setNavigationBar()
        
        // 订阅是否登录的信息
        isLoginVariable.asObservable().subscribe(
            onNext:{ isLogin in
                if isLogin {
                    self.navigationItem.leftBarButtonItem = nil
                }else{
                    let leftBarButton = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.presentLoginVC))
                    leftBarButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                    self.navigationItem.leftBarButtonItem = leftBarButton
                }
            }
        ).addDisposableTo(bag)
        
        // 去除 TabBar 上的横线
        tabBar.clipsToBounds = true
        
        tabBar.isTranslucent = false
        
        self.setViewControllers([HomeViewController(),ActivityViewController(),MineViewController()], animated: false)
        
        self.setCustomItem(title: "首页", image: #imageLiteral(resourceName: "tab_home"), selectedImage: #imageLiteral(resourceName: "tab_home"), index: 0)
        
        self.setCustomItem(title: "活动", image: #imageLiteral(resourceName: "tab_home"), selectedImage: #imageLiteral(resourceName: "tab_home"), index: 1)
        
        self.setCustomItem(title: "我的", image: #imageLiteral(resourceName: "tab_mine"), selectedImage: #imageLiteral(resourceName: "tab_mine"), index: 2)
        
        // 修改 TabBar 高亮图标的颜色
        tabBar.tintColor = #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.7843137255, alpha: 1)
    }
    
    func getHeight() -> CGFloat{
        return tabBar.frame.height
    }
    
    func getWidth() -> CGFloat{
        return tabBar.frame.width
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
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: nil)
        rightBarButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // 自定义返回按钮
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        backBarButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        let title = "小猴偷米"
        let attibutesTitle = NSMutableAttributedString.init(string: title)
        let length = (title as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        attibutesTitle.addAttributes(TextAttributesHelper.titleTextAttributes, range: titleRange)
        titleButton.setAttributedTitle(attibutesTitle, for: .normal)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.backBarButtonItem = backBarButton
        self.navigationItem.titleView = titleButton
    }
    
    @objc func presentLoginVC() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
