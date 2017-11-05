//
//  MineTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 05/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension MineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mineItem = self.mineItems[indexPath.section][indexPath.row]
        switch mineItem {
        case .Account(_):
            return 40
        case .Url(_):
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text("    " + self.dataSource.sectionModels[section].model).font(13).color(#colorLiteral(red: 0.5230805838, green: 0.5230805838, blue: 0.5230805838, alpha: 1))
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1)).tint(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1)).tint(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
    }
}

