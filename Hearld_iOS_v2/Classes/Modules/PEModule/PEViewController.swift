//
//  PEViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD
import Realm
import RealmSwift

class PEViewController: UIViewController {

    /* UI stuff */
    let containerView = UIView()
    var peCountLabel = UILabel()
    var peRemainLabel = UILabel()
    var remainDaysLabel = UILabel()
    var peTableView = UITableView()
    
    /* rxswift */
    let peViewModel = PEViewModel.shared
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String, PEModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "跑操和体侧"
        layoutUI()
        
        /* peTableView */
        peTableView.register(PETableViewCell.self, forCellReuseIdentifier: "PETableViewCell")
        peTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        // 订阅PE请求
        peViewModel.PEList.subscribe(
            onNext: { peArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first!
                
                self.peCountLabel.text = "跑操次数" + String(currentUser.peCount)
                self.peRemainLabel.text = "剩余次数" + String(45 - currentUser.peCount)
                self.remainDaysLabel.text = "剩余天数"
                if let peDays = HearldUserDefault.peDays {
                    self.remainDaysLabel.text = self.remainDaysLabel.text! + String(peDays)
                }
                
                self.peTableView.dataSource = nil
                Observable.just(self.createSectionModel(peArray))
                          .bind(to: self.peTableView.rx.items(dataSource: self.dataSource))
                          .addDisposableTo(self.bag)
        }, onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        peViewModel.prepareData(isRefresh: false, completionHandler: {})
    }
    
    private func layoutUI() {
        view.background(UIColor.white)
        if let navigationController = self.navigationController as? MainNavigationController {
            // 容器
            containerView.into(view).top(navigationController.getHeight() + 70).centerX().height(30).width(228)
            
            // 跑操次数
            peCountLabel.into(containerView).top(0).bottom(0).left(0).height(30).width(110).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
            
            // 剩余次数
            peRemainLabel.into(containerView).top(0).bottom(0).after(peCountLabel,8).right(0).height(30).width(110).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
            
            // 剩余天数
            remainDaysLabel.into(view).below(containerView,8).centerX().height(30).width(110).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
            
            // 体锻成绩
            peTableView.into(view).below(remainDaysLabel,20).left(5).right(5).bottom(5)
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "PETableViewCell", for: indexPath) as! PETableViewCell
            cell.pe = item
            return cell
        }
    }
    
    private func createSectionModel(_ peList: [PEModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: peList)]
    }

}
