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
import Realm
import RealmSwift

class MineViewController: UIViewController {
    
    var staticTableView = UITableView()
    fileprivate let MineItemSubject = PublishSubject<[MineItem]>()
    let bag = DisposeBag()
    
    enum MineItem{
        case Account(User)
        case Url(String)
    }
    
    // Mark: Model
    var mineItems : [[MineItem]] = []
    
    // dataSource
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,MineItem>

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(staticTableView)
        layoutSubviews()
        
        // 设置tableview
        staticTableView.delegate = self
        staticTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "Account")
        staticTableView.register(SubTitleTableViewCell.self, forCellReuseIdentifier: "SubTitle")
        setConfigureCell()
        staticTableView.estimatedRowHeight = 0
        staticTableView.estimatedSectionHeaderHeight = 0
        staticTableView.estimatedSectionFooterHeight = 0
        staticTableView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        
        // 订阅数据
        MineItemSubject.subscribe(
            onNext:{ itemArray in
                self.mineItems.append(itemArray)
                self.staticTableView.dataSource = nil
                Observable.just(self.createSectionModel(self.mineItems))
                    .bind(to: self.staticTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        }).addDisposableTo(bag)
        
        // 订阅select事件
        staticTableView.rx.itemSelected.asObservable().subscribe(
            onNext:{ indexPath in
                let mineItem = self.mineItems[indexPath.section][indexPath.row]
                switch mineItem {
                case .Account(_):
                    break
                case .Url(let url):
                    let webVC = WebViewController()
                    webVC.webUrl = URL(string: ApiHelper.changeHTTPtoHTTPS(url: url))
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
        }).addDisposableTo(bag)
        
        // 动态方法实现静态tableView,初始化数据
        let realm = try! Realm()
        let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first
        let user = MineItem.Account(currentUser!)
        MineItemSubject.onNext([user])
        
        let aboutUS = MineItem.Url("https://app.heraldstudio.com/about.htm?type=ios")
        MineItemSubject.onNext([aboutUS])
    }
    
    private func createSectionModel(_ itemLists: [[MineItem]]) -> [SectionTableModel]{
        var sections: [SectionTableModel] = []
        var section: SectionTableModel?
        for itemList in itemLists{
            switch itemList[0]{
            case .Account(_):
                section = SectionTableModel(model: "我的账户", items: itemList)
            case .Url(_):
                section = SectionTableModel(model: "", items: itemList)
            }
            sections.append(section!)
        }
        return sections
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let mineItem = self.mineItems[indexPath.section][indexPath.row]
            switch mineItem {
            case .Account(_):
                let cell = tv.dequeueReusableCell(withIdentifier: "Account", for: indexPath) as! NormalTableViewCell
                cell.normalLabel.text = "退出登录"
                return cell
            case .Url(let url):
                let cell = tv.dequeueReusableCell(withIdentifier: "SubTitle", for: indexPath) as! SubTitleTableViewCell
                cell.titleLabel.text = "关于小猴"
                cell.subTitleLabel.text = "当前版本: Beta2.0"
                cell.accessoryType = .disclosureIndicator
                cell.url = url
                return cell
            }
        }
    }
    
    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            staticTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            staticTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}
