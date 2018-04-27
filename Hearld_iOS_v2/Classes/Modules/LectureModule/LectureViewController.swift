//
//  LectureViewController.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 14/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources
import SVProgressHUD

class LectureViewController: UIViewController {
    var lectureTableView = UITableView()
    
    // 设置swiper
    let swiper = SwipeRefreshHeader()
    
    var viewModel = LectureViewModel()
    let bag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,LectureModel>
    
    // 讲座总次数
    var count:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子视图
        view.addSubview(lectureTableView)
        layoutSubviews()
        
        
        
        // 设置下拉刷新控件为列表页头视图
        lectureTableView.tableHeaderView = swiper
        
        // 订阅下滑刷新控件的刷新事件
        swiper.isEvent.asObservable().subscribe(
            onNext:{ isEvent in
                if isEvent == true{
                    self.showProgressDialog()
                    self.viewModel.prepareData(isRefresh: true){
                        self.hideProgressDialog()
                    }
                }
        }).addDisposableTo(bag)
        
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        lectureTableView.delegate = self
        lectureTableView.register(LectureTableViewCell.self, forCellReuseIdentifier: "Lecture")
        lectureTableView.register(LectureStatusTableViewCell.self, forCellReuseIdentifier: "lectureStatus")
        setConfigureCell()
        lectureTableView.separatorStyle = .none
        lectureTableView.estimatedRowHeight = 300
        lectureTableView.rowHeight = UITableViewAutomaticDimension
        lectureTableView.background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        // 订阅数据,保证视图的cell与model保持一致
        viewModel.LectureList.subscribe(
            onNext:{ lecturesArray in
                self.lectureTableView.dataSource = nil
                self.count = lecturesArray.count
                Observable.just(self.createSectionModel(lecturesArray))
                    .bind(to: self.lectureTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        

        
        // 准备数据,默认先查询数据库；设置导航栏
        viewModel.prepareData(isRefresh: false) {}
        setNavigationItem()
    }
    
    
    private func createSectionModel(_ lectureList: [LectureModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: lectureList)]
    }
    
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            
            if indexPath[1] == 0 {
                let cell = tv.dequeueReusableCell(withIdentifier: "lectureStatus", for: indexPath) as! LectureStatusTableViewCell
                
                cell.countLabel.text = "已听次数 " + String(self.count)
                cell.leftLabel.text = "剩余次数 " + String(8-self.count)
                
                return cell
            }else {
                let cell = tv.dequeueReusableCell(withIdentifier: "Lecture", for: indexPath) as! LectureTableViewCell
                
                // 日期
                cell.timeLabel.text = item.time
                // 地点
                cell.locationLabel.text = item.location
                
                return cell
            }
        }
    }

    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            lectureTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            lectureTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
    
    private func setNavigationItem() {
        let title = "人文讲座"
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.refresh))
        
        
        self.navigationItem.title = title
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func refresh() {
        self.showProgressDialog()
        self.viewModel.prepareData(isRefresh: true) {
            self.hideProgressDialog()
        }
    }
}
