//
//  GPATableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 25/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension GPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
