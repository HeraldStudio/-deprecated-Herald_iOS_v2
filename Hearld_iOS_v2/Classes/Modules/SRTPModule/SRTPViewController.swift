//
//  SRTPViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD
import Realm
import RealmSwift

class SRTPViewController: UIViewController {
    
    /* UI stuff */
    var creditLabel = UILabel()
    var statusLabel = UILabel()
    var srtpTableView = UITableView()
    
    /* rxswift */
    let srtpViewModel = SRTPViewModel.shared
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String,SRTPModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SRTP"
        layoutUI()
        
        /* SRTPTableView */
        srtpTableView.register(SRTPTableViewCell.self, forCellReuseIdentifier: "SRTP")
        srtpTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        /* 订阅SRTP请求 */
        srtpViewModel.SRTPList.subscribe (
            onNext: { srtpArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first!
                
                self.creditLabel.text = "SRTP学分 " + currentUser.points
                self.statusLabel.text = "SRTP状态 " + currentUser.grade
                
                self.srtpTableView.dataSource = nil
                Observable.just(self.createSectionModel(srtpArray)).bind(to: self.srtpTableView.rx.items(dataSource: self.dataSource)).addDisposableTo(self.bag)
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        srtpViewModel.prepareData(isRefresh: true, completionHandler: {})
    }
    
    private func layoutUI() {
        view.background(UIColor.white)
        if let navigationController = navigationController as? MainNavigationController {
            creditLabel.into(view).top(navigationController.getHeight() + 70).left(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
            
            statusLabel.into(view).top(navigationController.getHeight() + 70).right(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
            
            srtpTableView.into(view).below(creditLabel, 10).left(5).right(5).bottom(5)
            srtpTableView.isScrollEnabled = false
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "SRTP", for: indexPath) as! SRTPTableViewCell
            cell.srtp = item
            return cell
        }
    }
    
    private func createSectionModel(_ srtpList: [SRTPModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: srtpList)]
    }
}
