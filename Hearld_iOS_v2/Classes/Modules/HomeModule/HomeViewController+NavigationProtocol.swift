//
//  HomeTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: NavigationProtocol {
    func navigation(toVC viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigationPop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func present(VC viewController: UIViewController, completionHandler: @escaping () -> Void) {
        self.present(viewController, animated: true, completion: completionHandler)
    }
}
