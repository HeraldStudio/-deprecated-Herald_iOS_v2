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
        case .Switch(_):
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let mineItem = self.mineItems[section][0]
        switch mineItem {
        case .Account(_):
            return 50
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let mineItem = self.mineItems[section][0]
        switch mineItem {
        case .Switch(_):
            return 20
        default:
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let box = UIView()
        let label = UILabel()
        box.addSubview(label);
        label.left(8).bottom(4).width(200)
        label.text(self.dataSource.sectionModels[section].model).font(14).color(#colorLiteral(red: 0.5230805838, green: 0.5230805838, blue: 0.5230805838, alpha: 1))
        return box
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mineItem = self.mineItems[section][0]
        switch mineItem {
        case .Switch(_):
            let box = UIView()
            let label = UILabel()
            box.addSubview(label);
            label.left(8).top(4).width(screenRect.width)
            label.text("考试提醒为提前30分钟，其余为提前15分钟").font(14).color(#colorLiteral(red: 0.5230805838, green: 0.5230805838, blue: 0.5230805838, alpha: 1))
            return box
        default:
            let empty = UIView()
            return empty
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.background(#colorLiteral(red: 0.904571961, green: 0.904571961, blue: 0.904571961, alpha: 1)).tint(#colorLiteral(red: 0.904571961, green: 0.904571961, blue: 0.904571961, alpha: 1))
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.background(#colorLiteral(red: 0.904571961, green: 0.904571961, blue: 0.904571961, alpha: 1)).tint(#colorLiteral(red: 0.904571961, green: 0.904571961, blue: 0.904571961, alpha: 1))
    }
}

