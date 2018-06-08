//
//  GPAViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD
import Realm
import RealmSwift

class GPAViewController: UIViewController {
    
    /* UI stuff */
    var creditLabel = UILabel()
    var noMaskCreditLabel = UILabel()
    var computedTimeLabel = UILabel()
    var gpaTableView = UITableView()
    
    /* rxswift */
    let gpaViewModel = GPAViewModel.shared
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String,GPAModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "成绩"
        layoutUI()
        
        /* GPATableView */
        gpaTableView.register(GPATableViewCell.self, forCellReuseIdentifier: "GPATableViewCell")
        gpaTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        /* 订阅viewModel */
        gpaViewModel.GPAList.subscribe(
            onNext: { gpaArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HeraldUserDefault.uuid!)'").first!
                
                self.creditLabel.text = "绩点 " + currentUser.gpa
                self.noMaskCreditLabel.text = "首修 " + currentUser.gpaBeforeMakeup
                let calcutionTime = currentUser.gpaCalcutionTime.substring(NSRange(location: 0, length: currentUser.gpaCalcutionTime.length()-3))
                let date = TimeConvertHelper.convert(from: calcutionTime)
                let displayTime = TimeConvertHelper.convert(from: date)
                self.computedTimeLabel.text = displayTime
                
                self.gpaTableView.dataSource = nil
                Observable.just(self.createSectionModel(gpaArray))
                          .bind(to: self.gpaTableView.rx.items(dataSource: self.dataSource))
                          .addDisposableTo(self.bag)
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        gpaViewModel.prepareData(isRefresh: false, completionHandler: {})
    }
    
    private func layoutUI() {
        view.background(UIColor.white)
        if let navigationController = self.navigationController as? MainNavigationController {
            noMaskCreditLabel.into(view).top(navigationController.getHeight() + 70).centerX().width(100).height(30).background(HeraldColorHelper.LabelBgColor.PrimaryBg).font(16,.semibold).align(.center)
            
            creditLabel.into(view).top(navigationController.getHeight() + 70).before(noMaskCreditLabel, 3).height(30).width(100).background(HeraldColorHelper.LabelBgColor.PrimaryBg).font(16,.semibold).align(.center)
            
            computedTimeLabel.into(view).top(navigationController.getHeight() + 70).after(noMaskCreditLabel, 3).height(30).width(100).background(HeraldColorHelper.LabelBgColor.PrimaryBg).font(16,.semibold).align(.center)
            
            gpaTableView.into(view).below(creditLabel, 10).left(5).right(5).bottom(5)
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "GPATableViewCell", for: indexPath) as! GPATableViewCell
            cell.gpa = item
            return cell
        }
    }
    
    private func createSectionModel(_ gpaList: [GPAModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: gpaList)]
    }
}
