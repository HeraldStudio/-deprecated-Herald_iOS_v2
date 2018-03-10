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
        case Card([CardModel])
        case Info([InfoModel])
    }
    
    // tableView & dataSource
    var homeTableView = UITableView()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,HomeItem>
    
    // ViewModels
    var carouselFigureViewModel = CarouselFigureViewModel()
    var infoViewModel = InfoViewModel()
    var cardViewModel = CardViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableView)
        layoutUI()
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        homeTableView.delegate = self
        homeTableView.register(CarouselFigureCell.self, forCellReuseIdentifier: "CarouselFigure")
        homeTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "Card")
        homeTableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "Info")
        setConfigureCell()
        homeTableView.separatorStyle = .none
        homeTableView.estimatedRowHeight = 300
        homeTableView.rowHeight = UITableViewAutomaticDimension
        
        // 订阅viewModel
        let carouselObservable = carouselFigureViewModel.CarouselFigures
        let cardObservable = cardViewModel.Cards
        let infoObservable = infoViewModel.Info
        
        Observable.combineLatest(carouselObservable, cardObservable, infoObservable) {
            (figureList: [CarouselFigureModel], cardList: [CardModel], infoList: [InfoModel]) in
                var items: [HomeItem] = []
                items.append(HomeItem.Carousel(figureList))
                items.append(HomeItem.Info(infoList))
                items.append(HomeItem.Card(cardList))
                return items
            }.map { (sections: [HomeItem]) -> [SectionTableModel] in
                return self.createSectionModel(sections)
            }.bind(to: self.homeTableView.rx.items(dataSource: self.dataSource)).addDisposableTo(bag)
        
        // prepareData
        carouselFigureViewModel.prepareData()
        cardViewModel.prepareData()
        infoViewModel.prepareData()
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
            case .Card(let cardList):
                let cell = tv.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! CardTableViewCell
                cell.cardList = cardList
                return cell
            case .Info(let infoList):
                let cell = tv.dequeueReusableCell(withIdentifier: "Info", for: indexPath) as! InfoTableViewCell
                cell.infoList = infoList
                return cell
            }
        }
    }
    
    private func createSectionModel(_ items: [HomeItem]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: items)]
    }
    
    private func layoutUI() {
        homeTableView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        if let navigationController = self.navigationController as? MainNavigationController{
            homeTableView.frame = CGRect(x: 0,
                                         y: navigationController.getHeight(),
                                         width: screenRect.width,
                                         height: screenRect.height - navigationController.getHeight())
            homeTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
}
