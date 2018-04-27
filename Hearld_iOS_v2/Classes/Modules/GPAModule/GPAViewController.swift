//
//  GPAViewController.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 24/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
import SnapKit
import SVProgressHUD

class GPAViewController: UIViewController {
    var GPATableView = UITableView()
    
    var viewModel = GPAViewModel()
    let bag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,GPAModel>
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子视图
        view.addSubview(GPATableView)
        layoutSubviews()
        
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        GPATableView.delegate = self
        GPATableView.register(GPATableViewCell.self, forCellReuseIdentifier: "GPA")
        GPATableView.register(GPAStatusTableViewCell.self, forCellReuseIdentifier: "GPAStatus")
        setConfigureCell()
        setConfigureSection()
        GPATableView.separatorStyle = .none
        GPATableView.estimatedRowHeight = 300
        GPATableView.rowHeight = UITableViewAutomaticDimension
        GPATableView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        // 订阅数据,保证视图的cell与model保持一致
        viewModel.GPAList.subscribe(
            onNext:{ gpaArray in
                self.GPATableView.dataSource = nil
                Observable.just(self.createSectionModel(gpaArray))
                    .bind(to: self.GPATableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        
        
        // 准备数据,默认先查询数据库；设置导航栏
        viewModel.prepareData(isRefresh: false) {}
        setNavigationItem()
    }
    
    
    private func createSectionModel(_ gpaList: [GPAModel]) -> [SectionTableModel]{
        var sectionList: [SectionTableModel] = []
        var gpaSemesterList: [GPAModel] = []
        
        var semester = gpaList[0].semester
        gpaSemesterList.append(gpaList[0])
        
        for item in gpaList.dropFirst() {
            if semester != item.semester {
                sectionList.append(SectionTableModel(model: semester, items: gpaSemesterList))
                
                //清除所有数据，准备存入下一个学期的数据
                semester = item.semester
                gpaSemesterList.removeAll()
            }else {
                gpaSemesterList.append(item)
            }
        }
        return sectionList
    }
    
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "GPA", for: indexPath) as! GPATableViewCell
            // 课程
            cell.nameLabel.text = item.courseName
            // 得分和学分
            cell.scoreLabel.text = item.score + "(" + item.credit + "学分)"
            
            return cell
        }
    }
    
    private func setConfigureSection() {
        dataSource.titleForHeaderInSection = { (dataSource, sectionIndex) in
            return dataSource[sectionIndex].model
        }
    }
    
    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            GPATableView.frame = CGRect(x: 0,
                                            y: navigationController.getHeight(),
                                            width: screenRect.width,
                                            height: screenRect.height - navigationController.getHeight())
            GPATableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
    
    private func setNavigationItem() {
        let title = "成绩查询"
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


    



