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
    fileprivate let MineItemSubject = PublishSubject<[[MineItem]]>()
    let bag = DisposeBag()
    
    enum MineItem{
        case Account(User)
        case Url(String)
        case Switch(String)
    }
    
    // Mark: Model
    var mineItems : [[MineItem]] = []
    
    /// 静态元素
    /* Account */
    var user = User()
    /* Url */
    let aboutUS = MineItem.Url("https://app.heraldstudio.com/about.htm?type=ios")
    /* Switch*/
    let lesson = MineItem.Switch("上课提醒")
    let experiment = MineItem.Switch("实验提醒")
    let test = MineItem.Switch("考试提醒")
    
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
        staticTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "Switch")
        setConfigureCell()
        // iOS11的bug，为显示tableViewHeader
        staticTableView.estimatedRowHeight = 0
        staticTableView.estimatedSectionHeaderHeight = 0
        staticTableView.estimatedSectionFooterHeight = 0
        
        // 订阅数据
        MineItemSubject.subscribe(
            onNext:{ itemArray in
                self.staticTableView.dataSource = nil
                Observable.just(self.createSectionModel(itemArray))
                    .bind(to: self.staticTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        }).addDisposableTo(bag)
        
        // 订阅select事件
        staticTableView.rx.itemSelected.asObservable().subscribe(
            onNext:{ indexPath in
                let mineItem = self.mineItems[indexPath.section][indexPath.row]
                switch mineItem {
                case .Account(_):
                    if HearldUserDefault.isLogin == true {
                        let alert = UIAlertController(title: "提示", message: "您确定要退出登录吗", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { action in
                            HearldUserDefault.isLogin = false
                            HearldUserDefault.uuid = ""
                        }))
                        self.present(alert, animated: true)
                    }else {
                        let loginVC = LoginViewController()
                        self.present(loginVC, animated: true, completion: nil)
                    }
                case .Url(let url):
                    let webVC = WebViewController()
                    webVC.webUrl = URL(string: ApiHelper.changeHTTPtoHTTPS(url: url))
                    self.navigationController?.pushViewController(webVC, animated: true)
                default: break
                }
        }).addDisposableTo(bag)
        
        // 动态方法实现静态tableView,初始化数据
        let realm = try! Realm()
        let results = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'")
        if results.count > 0{
            user = results.first!
        }
        
        //订阅是否登录的信息
        isLoginVariable.asObservable().subscribe(
            onNext:{ isLogin in
                if isLogin {
                    self.prepareData()
                }else{
                    self.user = User()
                    self.prepareData()
                }
        }).addDisposableTo(bag)
        
        prepareData()
    }
    
    // 准备数据
    private func prepareData() {
        self.mineItems.removeAll()
        
        self.mineItems.append([MineItem.Account(self.user)])
        self.mineItems.append([self.lesson,self.experiment,self.test])
        self.mineItems.append([self.aboutUS])
        
        self.MineItemSubject.onNext(self.mineItems)
    }
    
    // 构造[SectionModel]
    private func createSectionModel(_ itemLists: [[MineItem]]) -> [SectionTableModel]{
        var sections: [SectionTableModel] = []
        var section: SectionTableModel?
        for itemList in itemLists{
            switch itemList[0]{
            case .Account(_):
                section = SectionTableModel(model: "我的账户", items: itemList)
            case .Url(_):
                section = SectionTableModel(model: "", items: itemList)
            case .Switch(_):
                section = SectionTableModel(model: "", items: itemList)
            }
            sections.append(section!)
        }
        return sections
    }
    
    private func setConfigureCell() {
        /*
         * bug to fix:
         * cell.accessoryType
         * cell.cell.accessoryView 调用有问题
         */
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let mineItem = self.mineItems[indexPath.section][indexPath.row]
            switch mineItem {
            case .Account(_):
                let cell = tv.dequeueReusableCell(withIdentifier: "Account", for: indexPath) as! NormalTableViewCell
                cell.normalLabel.text = (HearldUserDefault.isLogin! ? "退出登录" : "立即登录")
                return cell
            case .Url(let url):
                let cell = tv.dequeueReusableCell(withIdentifier: "SubTitle", for: indexPath) as! SubTitleTableViewCell
                cell.titleLabel.text = "关于小猴"
                cell.subTitleLabel.text = "当前版本: Beta2.0"
                cell.accessoryType = .disclosureIndicator
                cell.url = url
                return cell
            case .Switch(let text):
                let cell = tv.dequeueReusableCell(withIdentifier: "Switch", for: indexPath) as! SwitchTableViewCell
                cell.wordLabel.text = text
                cell.remindText = text
//                cell.accessoryView = UISwitch()
                return cell
            }
        }
    }
    
    private func layoutSubviews() {
        staticTableView.separatorStyle = .singleLine
        staticTableView.background(#colorLiteral(red: 0.904571961, green: 0.904571961, blue: 0.904571961, alpha: 1))
        if let navigationController = self.navigationController as? MainNavigationController{
            staticTableView.frame = CGRect(x: 0,
                                           y: navigationController.getHeight(),
                                           width: screenRect.width,
                                           height: screenRect.height - navigationController.getHeight())
            staticTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}
