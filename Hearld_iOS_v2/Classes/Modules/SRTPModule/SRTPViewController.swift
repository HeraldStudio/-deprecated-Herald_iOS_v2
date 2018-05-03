//
//  SRTPViewController.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 25/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources
import SVProgressHUD

class SRTPViewController: UIViewController {
    var statusView = UILabel()
    var srtpTableView = UITableView()
    
    // 设置swiper
    let swiper = SwipeRefreshHeader()
    
    var viewModel = SRTPViewModel.shared
    let bag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,SRTPModel>
    
    // SRTP总分
    var totalCredit:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子视图
        view.addSubview(srtpTableView)
        layoutSubviews()
        
        
        // 设置下拉刷新控件为列表页头视图
        srtpTableView.tableHeaderView = swiper
        
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
        
        
        // 注册SRTP Cell以及Status Cell并设置ConfigureCell以及ConfigureAnimation
        srtpTableView.delegate = self
        srtpTableView.register(SRTPTableViewCell.self, forCellReuseIdentifier: "SRTP")
        srtpTableView.register(SRTPStatusTableViewCell.self, forCellReuseIdentifier: "SRTPStatus")
        setConfigureCell()
        srtpTableView.separatorStyle = .none
        srtpTableView.estimatedRowHeight = 300
        srtpTableView.rowHeight = UITableViewAutomaticDimension
        srtpTableView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        
        // 订阅数据,保证视图的cell与model保持一致
        viewModel.SRTPList.subscribe(
            onNext:{ srtpArray in
                self.srtpTableView.dataSource = nil
                Observable.just(self.createSRTPSectionModel(srtpArray))
                    .bind(to: self.srtpTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        
        
        // 准备数据,默认先查询数据库；设置导航栏
        viewModel.prepareData(isRefresh: false) {}
        setNavigationItem()
    }
    
    
    private func createSRTPSectionModel(_ srtpList: [SRTPModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: srtpList)]
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            if indexPath[1] == 0 {
                let cell = tv.dequeueReusableCell(withIdentifier: "SRTPStatus", for: indexPath) as! SRTPStatusTableViewCell
                cell.scoreLabel.text = "SRTP状态: " + item.project
//                cell.totalLabel.text = "SRTP学分: " + item.total
                
                return cell
            }else {
                let cell = tv.dequeueReusableCell(withIdentifier: "SRTP", for: indexPath) as! SRTPTableViewCell
                
                // 项目
//                cell.projectLabel.text = item.id.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                
                // 项目类型和时间
                cell.infoLabel.text = item.date + "·" + item.type
                
                // 实际得分和比重
//                if item.proportion.isEmpty {
//                    cell.creditLabel.text = item.credit
//                }else {
//                    cell.creditLabel.text = item.credit + "(" + item.proportion + ")"
//                }
                
                return cell
            }
        }
    }
    
    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            srtpTableView.frame = CGRect(x: 0,
                                            y: navigationController.getHeight(),
                                            width: screenRect.width,
                                            height: screenRect.height - navigationController.getHeight())
            srtpTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
    
    private func setNavigationItem() {
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.refresh))
        rightButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        backButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        let title = "SRTP"
        let attibutesTitle = NSMutableAttributedString.init(string: title)
        let length = (title as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        attibutesTitle.addAttributes(TextAttributesHelper.titleTextAttributes, range: titleRange)
        titleButton.setAttributedTitle(attibutesTitle, for: .normal)
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.titleView = titleButton
    }
    
    @objc func refresh() {
        self.showProgressDialog()
        self.viewModel.prepareData(isRefresh: true) {
            self.hideProgressDialog()
        }
    }
}
