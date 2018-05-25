//
//  ActivityViewController.swift
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
import SDWebImage
import SVProgressHUD

class ActivityViewController: UIViewController {

    var activityTableView = UITableView()
    // 初始活动页数
    var page = 1
    
    // 设置swiper和loader
    let swiper = SwipeRefreshHeader()
    let puller = PullLoadFooter()
    
    var viewModel = ActivityViewModel()
    let bag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,ActivityModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子视图
        view.addSubview(activityTableView)
        layoutUI()
        
        // 设置下拉刷新控件为列表页头视图
        activityTableView.tableHeaderView = swiper
        activityTableView.tableFooterView = puller
        
        // 订阅下滑刷新控件的刷新事件
        swiper.isEvent.asObservable().subscribe(
            onNext:{ isEvent in
                if isEvent == true{
                    self.showProgressDialog()
                    self.puller.enable()
                    self.viewModel.prepareData(isRefresh: true){
                        self.hideProgressDialog()
                        self.page = 1
                    }
                }
        }).addDisposableTo(bag)
        
        // 订阅上拉刷新控件的刷新事件
        puller.isEvent.asObservable().subscribe(
            onNext:{ isEvent in
                if isEvent == true{
                    self.showProgressDialog()
                    self.viewModel.requestNextPage(from: String(describing: (self.page + 1)), completionHandler: {
                        self.page += 1
                        self.hideProgressDialog()
                    }, failedHandler: {
                        self.hideProgressDialog()
                        SVProgressHUD.showInfo(withStatus: "没有更多数据")
                        self.puller.disable("没有更多数据")
                    })
                }
        }).addDisposableTo(bag)
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        activityTableView.delegate = self
        activityTableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "Activity")
        setConfigureCell()
        activityTableView.separatorStyle = .none
        activityTableView.estimatedRowHeight = 300
        activityTableView.rowHeight = UITableViewAutomaticDimension
        
        // 订阅数据,保证视图的cell与model保持一致
        viewModel.ActivityList.subscribe(
            onNext:{ activityArray in
                self.activityTableView.dataSource = nil
                self.viewModel.model += activityArray
                Observable.just(self.createSectionModel(self.viewModel.model))
                    .bind(to: self.activityTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
            },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        // 订阅select事件
        activityTableView.rx.itemSelected.asObservable().subscribe(
            onNext:{ indexPath in
                let activity = self.viewModel.model[indexPath.row]
                let url = activity.detail_url
                let webVC = WebViewController()
                webVC.webUrl = URL(string: ApiHelper.changeHTTPtoHTTPS(url: url))
                webVC.navigationItem.title = activity.association
                self.navigationController?.pushViewController(webVC, animated: true)
        }).addDisposableTo(bag)
        
        // 准备数据,默认先查询数据库
        viewModel.prepareData(isRefresh: false) {}
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Activity", for: indexPath) as! ActivityTableViewCell
            
            // 标题
            cell.titleLabel.text = item.title
            
            // 状态
            cell.stateLabel.text = item.state.rawValue
            switch item.state{
            case .Coming:
                cell.bg_color = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                cell.text_color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case .Going:
                cell.bg_color = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                cell.text_color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case .Gone:
                cell.bg_color = #colorLiteral(red: 0.8871227225, green: 0.8871227225, blue: 0.8871227225, alpha: 1)
                cell.text_color = #colorLiteral(red: 0.4568924492, green: 0.4568924492, blue: 0.4568924492, alpha: 1)
            }
            
            // 图片
            cell.picture.sd_setImage(with: URL(string: item.pic_url), placeholderImage: #imageLiteral(resourceName: "default_herald"), options: SDWebImageOptions.retryFailed)
            
            // 介绍
            cell.introductionLabel.text = item.introduction
            
            return cell
        }
    }
    
    private func createSectionModel(_ activityList: [ActivityModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: activityList)]
    }
    
    private func layoutUI() {
        activityTableView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        if let navigationController = self.navigationController as? MainNavigationController{
            activityTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            activityTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}
