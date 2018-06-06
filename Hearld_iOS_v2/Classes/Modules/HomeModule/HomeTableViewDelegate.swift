//
//  HomeTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

protocol navigationProtocol {
    func navigation(toVC viewController: UIViewController)
    func navigationPop(animated: Bool)
    func present(VC viewController: UIViewController, completionHandler: @escaping ()->())
}

extension HomeViewController: navigationProtocol {
    func navigation(toVC viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigationPop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func present(VC viewController: UIViewController, completionHandler: @escaping ()->()) {
        self.present(viewController, animated: true, completion: completionHandler)
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: CarouselFigureCellProtocol {
    func navigationPush(to vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
