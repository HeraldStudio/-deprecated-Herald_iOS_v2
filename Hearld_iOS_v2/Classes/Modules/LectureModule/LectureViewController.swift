//
//  LectureViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD

class LectureViewController: UIViewController {

    /* UI stuff */
    var staticLabel = UILabel()
    var doneLabel = UILabel()
    var remainLabel = UILabel()
    var lectureTableView = UITableView()
    
    /* rxswift */
    let lectureViewModel = LectureViewModel.shared
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String,LectureModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "人文讲座"
        layoutUI()
        
        /* lectureTableView */
        lectureTableView.register(LectureTableViewCell.self, forCellReuseIdentifier: "LectureTableViewCell")
        lectureTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        // 订阅Lecture请求
        lectureViewModel.LectureList.subscribe(
            onNext: { lectureArray in
                self.doneLabel.text = "已听讲座次数 " + String(lectureArray.count)
                let remianCount = (lectureArray.count) > 8 ? 0 : (8 - lectureArray.count)
                self.remainLabel.text = "剩余讲座次数 " + String(remianCount)
                
                self.lectureTableView.dataSource = nil
                Observable.just(self.createSectionModel(lectureArray)).bind(to: self.lectureTableView.rx.items(dataSource: self.dataSource)).addDisposableTo(self.bag)
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        lectureViewModel.prepareData(isRefresh: true, completionHandler: {})
    }

    private func layoutUI() {
        view.background(UIColor.white)
        if let navigationController = self.navigationController as? MainNavigationController {
            doneLabel.into(view).top(navigationController.getHeight() + 70).left(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(17,.semibold).align(.center)
            
            remainLabel.into(view).top(navigationController.getHeight() + 70).right(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(17,.semibold).align(.center)
            
            lectureTableView.into(view).below(doneLabel, 25).left(5).right(5).bottom(5)
            lectureTableView.isScrollEnabled = false
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "LectureTableViewCell", for: indexPath) as! LectureTableViewCell
            cell.lecture = item
            return cell
        }
    }
    
    private func createSectionModel(_ lectureList: [LectureModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: lectureList)]
    }
}
