//
//  NoticeViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD

class NoticeViewController: UIViewController {
    
    /* ViewModel */
    var viewModel = NoticeViewModel()
    
    /* UI stuff */
    let jwcButton = UIButton()
    let srtpButton = UIButton()
    let collegeButton = UIButton()
    let noticeTableView = UITableView()
    
    /* rxswift */
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String,NoticeModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: "NoticeTableViewCell")
        noticeTableView.allowsSelection = false
        noticeTableView.estimatedRowHeight = 95
        noticeTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        /* 订阅ViewModel */
        viewModel.noticeList.subscribe(
            onNext: { noticeArray in
            self.noticeTableView.dataSource = nil
                Observable.just(self.createSectionModel(noticeArray))
                          .bind(to: self.noticeTableView.rx.items(dataSource: self.dataSource))
                          .addDisposableTo(self.bag)
        }, onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        viewModel.prepareData(isRefresh: true, completionHandler: {})
    }
    
    private func layoutUI() {
        if let navigationController = self.navigationController as? MainNavigationController {
            
            let srtpAttrString = NSMutableAttributedString.init(string: "SRTP")
            srtpAttrString.font(16, FontWeight.semibold, NSMakeRange(0, 4))
            srtpButton.into(view).top(navigationController.getHeight() + 55).centerX().width(55).height(30).background(HeraldColorHelper.LabelBgColor.PrimaryBg).attributedTitle(srtpAttrString)
            
            let jwcAttrString = NSMutableAttributedString.init(string: "教务处")
            jwcAttrString.font(16,FontWeight.semibold, NSMakeRange(0, 3))
            jwcButton.into(view).top(navigationController.getHeight() + 55).before(srtpButton,10).width(55).height(30).background(HeraldColorHelper.LabelBgColor.PrimaryBg).attributedTitle(jwcAttrString)
            
            let collegeAttrString = NSMutableAttributedString.init(string: "学院")
            collegeAttrString.font(16,FontWeight.semibold, NSMakeRange(0, 2))
            collegeButton.into(view).top(navigationController.getHeight() + 55).after(srtpButton,10).width(45).height(30).background(HeraldColorHelper.LabelBgColor.PrimaryBg).attributedTitle(collegeAttrString)
            
            noticeTableView.into(view).below(jwcButton,10).left(10).right(10).bottom(0)
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as! NoticeCell
            cell.notice = item
            return cell
        }
    }
    
    private func createSectionModel(_ noticeList: [NoticeModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: noticeList)]
    }
}
