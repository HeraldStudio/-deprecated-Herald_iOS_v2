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
        case Curriculum([curriculumItem])
    }
    
    /* tableView & dataSource */
    var homeTableView = UITableView()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,HomeItem>
    
    /* ViewModels */
    var carouselFigureViewModel = CarouselFigureViewModel()
    var infoViewModel = InfoViewModel()
    var curriculumViewModel = CurriculumViewModel.shared
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        homeTableView.register(CarouselFigureCell.self, forCellReuseIdentifier: "CarouselFigure")
        homeTableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "Info")
        homeTableView.register(CurriculumTableViewCell.self, forCellReuseIdentifier: "Curriculum")
        setConfigureCell()
        homeTableView.separatorStyle = .none
        homeTableView.allowsSelection = false
        homeTableView.estimatedRowHeight = 300
        
        // 订阅viewModel
        let carouselObservable = carouselFigureViewModel.CarouselFigures
        let infoObservable = infoViewModel.Info
        let curriculumObservable = curriculumViewModel.curriculumTable
        
        Observable.combineLatest(carouselObservable,infoObservable,curriculumObservable) {
            (figureList: [CarouselFigureModel],infoList: [infoItem],curriculumTable: [curriculumItem]) in
                var items: [HomeItem] = []
                items.append(HomeItem.Carousel(figureList))
                items.append(HomeItem.Info(infoList))
                items.append(HomeItem.Curriculum(curriculumTable))
                return items
            }.map { (sections: [HomeItem]) -> [SectionTableModel] in
                return self.createSectionModel(sections)
            }.bind(to: self.homeTableView.rx.items(dataSource: self.dataSource)).addDisposableTo(bag)
        
        // prepareData
        carouselFigureViewModel.prepareData()
        infoViewModel.prepareData()
        curriculumViewModel.prepareData(isRefresh: true, completionHandler: {})
    }
    
    /**
      坑注意
      AppDelegate中加载tabBarViewController时，直接调用了其的viewDidLoad，此时并未push进navigationController
      所以在homeVC的navigationController为nil
      目前解决办法是在viewWillAppear再调用一次layoutUI
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
                DispatchQueue.global().async { cell.strpViewModel.prepareData(isRefresh: true, completionHandler: {}) }
                DispatchQueue.global().async { cell.lectureViewModel.prepareData(isRefresh: true, completionHandler: {}) }
                DispatchQueue.global().async { cell.gpaViewModel.prepareData(isRefresh: true, completionHandler: {}) }
                DispatchQueue.global().async { cell.cardViewModel.prepareData(isRefresh: true, completionHandler: {}) }
                DispatchQueue.global().async { cell.peViewModel.prepareData(isRefresh: true, completionHandler: {}) }
                return cell
            case .Curriculum(_):
                let cell = tv.dequeueReusableCell(withIdentifier: "Curriculum", for: indexPath) as! CurriculumTableViewCell
                return cell
            }
        }
    }
    
    private func createSectionModel(_ items: [HomeItem]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: items)]
    }
    
    private func layoutUI() {
        homeTableView.into(view).background(HeraldColorHelper.GeneralColor.ToolBg)
        if let navigationController = self.navigationController as? MainNavigationController{
            homeTableView.frame = CGRect(x: 0,
                                         y: navigationController.getHeight(),
                                         width: screenRect.width,
                                         height: screenRect.height - navigationController.getHeight())
            homeTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}

protocol NavigationProtocol {
    func navigation(toVC viewController: UIViewController)
    func navigationPop(animated: Bool)
    func present(VC viewController: UIViewController, completionHandler: @escaping () -> Void)
}
