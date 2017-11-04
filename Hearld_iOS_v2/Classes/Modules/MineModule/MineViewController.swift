//
//  MineViewController.swift
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

class MineViewController: UIViewController {
    
    var staticTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(staticTableView)
        
    }
    
    private func layoutSubviews(){
        if let navigationController = self.navigationController as? MainNavigationController{
            staticTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            staticTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
