//
//  HomeTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate {
}

extension HomeViewController: CarouselFigureCellProtocol {
    func navigationPush(to vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
