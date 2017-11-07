//
//  HomeViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {
    
    var homeTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func layoutSubViews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            homeTableView.frame = CGRect(x: 0,
                                         y: navigationController.getHeight(),
                                         width: screenRect.width,
                                         height: screenRect.height - navigationController.getHeight())
            homeTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}
