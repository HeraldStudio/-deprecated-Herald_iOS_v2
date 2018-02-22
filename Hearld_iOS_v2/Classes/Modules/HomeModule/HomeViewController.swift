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
    
    // tableView & dataSource
    var homeTableView = UITableView()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,[CarouselFigureModel]>
    
    // ViewModels
    var carouselFigureViewModel = CarouselFigureViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableView)
        layoutSubViews()
        
        // 注册Cell并设置ConfigureCell以及ConfigureAnimation
        homeTableView.delegate = self
        homeTableView.register(CarouselFigureCell.self, forCellReuseIdentifier: "CarouselFigure")
        setConfigureCell()
        homeTableView.separatorStyle = .none
        homeTableView.estimatedRowHeight = 300
        homeTableView.rowHeight = UITableViewAutomaticDimension
        
        // 订阅viewModel
        carouselFigureViewModel.CarouselFigures.subscribe(
            onNext:{ figureArray in
                self.homeTableView.dataSource = nil
                Observable.just(self.createSectionModel(figureArray))
                    .bind(to: self.homeTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
        },
            onError:{error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        // prepareData
        carouselFigureViewModel.prepareData()
    }
    
    /*
     * 坑注意
     * AppDelegate中加载tabBarViewController时，直接调用了其的viewDidLoad，此时并未push进navigationController
     * 所以在homeVC的navigationController为nil
     * 目前解决办法是在viewWillAppear再调用一次layoutSubViews
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setConfigureCell() {
        self.dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "CarouselFigure", for: indexPath) as! CarouselFigureCell
            cell.itemArray = item
            cell.deleagte = self
            return cell
        }
    }
    
    private func createSectionModel(_ figureList: [CarouselFigureModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: [figureList])]
    }
    
    private func layoutSubViews() {
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
