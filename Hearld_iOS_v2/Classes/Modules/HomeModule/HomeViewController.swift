//
//  HomeViewController.swift
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

class HomeViewController: UIViewController {
    
    enum HomeItem{
        case Carousel([CarouselFigureModel])
        case Info([infoItem])
        case Notice([NoticeModel])
    }
    
    // tableView & dataSource
    var homeTableView = UITableView()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,HomeItem>
    
    // ViewModels
    var carouselFigureViewModel = CarouselFigureViewModel()
    var infoViewModel = InfoViewModel()
    var noticeViewModel = NoticeViewModel()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableView)
        layoutUI()
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        homeTableView.delegate = self
        homeTableView.register(CarouselFigureCell.self, forCellReuseIdentifier: "CarouselFigure")
        homeTableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "Info")
        homeTableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: "Notice")
        setConfigureCell()
        homeTableView.separatorStyle = .none
        homeTableView.allowsSelection = false
        homeTableView.estimatedRowHeight = 300
        
        // 订阅viewModel
        let carouselObservable = carouselFigureViewModel.CarouselFigures
        let infoObservable = infoViewModel.Info
        let noticeObservale = noticeViewModel.noticeList
        
        Observable.combineLatest(carouselObservable,infoObservable,noticeObservale) {
            (figureList: [CarouselFigureModel],infoList: [infoItem], noticeList: [NoticeModel]) in
                var items: [HomeItem] = []
                items.append(HomeItem.Carousel(figureList))
                items.append(HomeItem.Info(infoList))
                items.append(HomeItem.Notice(noticeList))
                return items
            }.map { (sections: [HomeItem]) -> [SectionTableModel] in
                return self.createSectionModel(sections)
            }.bind(to: self.homeTableView.rx.items(dataSource: self.dataSource)).addDisposableTo(bag)
        
        // prepareData
        carouselFigureViewModel.prepareData()
        infoViewModel.prepareData()
        noticeViewModel.prepareData(isRefresh: false, completionHandler: {})
    }
    
    /*
     * 坑注意
     * AppDelegate中加载tabBarViewController时，直接调用了其的viewDidLoad，此时并未push进navigationController
     * 所以在homeVC的navigationController为nil
     * 目前解决办法是在viewWillAppear再调用一次layoutUI
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setConfigureCell() {
        self.dataSource.configureCell = {(_,tv,indexPath,item) in
            switch item {
            case .Carousel(let figureList):
                let cell = tv.dequeueReusableCell(withIdentifier: "CarouselFigure", for: indexPath) as! CarouselFigureCell
                cell.itemArray = figureList
                cell.deleagte = self
                return cell
            case .Info(let infoList):
                let cell = tv.dequeueReusableCell(withIdentifier: "Info", for: indexPath) as! InfoTableViewCell
                cell.infoList = infoList
                cell.delegate = self
                DispatchQueue.global().async {
                    cell.strpViewModel.prepareData(isRefresh: true, completionHandler: {})
                    cell.lectureViewModel.prepareData(isRefresh: true, completionHandler: {})
                    cell.gpaViewModel.prepareData(isRefresh: true, completionHandler: {})
                    cell.cardViewModel.prepareData(isRefresh: true, completionHandler: {})
                }
                return cell
            case .Notice(let noticeList):
                let cell = tv.dequeueReusableCell(withIdentifier: "Notice", for: indexPath) as! NoticeTableViewCell
                cell.noticeList = noticeList
                return cell
            }
        }
    }
    
    private func createSectionModel(_ items: [HomeItem]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: items)]
    }
    
    private func layoutUI() {
        homeTableView.background(HeraldColorHelper.background)
        if let navigationController = self.navigationController as? MainNavigationController{
            homeTableView.frame = CGRect(x: 0,
                                         y: navigationController.getHeight(),
                                         width: screenRect.width,
                                         height: screenRect.height - navigationController.getHeight())
            homeTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}

extension HomeViewController : addSubViewProtocol {
    func addSubViewFromCell(_ subView: UIView) {
        view.addSubview(subView)
    }
    
    func changeAlphaTo(_ num: CGFloat) {
        homeTableView.alpha = num
    }
}
