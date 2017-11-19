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
        homeTableView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setConfigureCell() {
        self.dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "CarouselFigure", for: indexPath) as! CarouselFigureCell
            
            cell.pageControl.numberOfPages = item.count
            cell.CarouselFigure.removeAllSubviews()
            let pictureFrame = cell.CarouselFigure.bounds
            
            //设置整体轮播图的contentSize
            cell.CarouselFigure.contentSize = CGSize(width: pictureFrame.size.width * CGFloat(item.count),
                                                     height: pictureFrame.size.height)
            
            for index in 0..<item.count{
                let figureImage = UIImageView()
                figureImage.frame = CGRect(x: pictureFrame.size.width * CGFloat(index),
                                           y: 0,
                                           width: pictureFrame.size.width,
                                           height: pictureFrame.size.height)
                figureImage.contentMode = .scaleToFill
                figureImage.sd_setImage(with: URL(string: item[index].picture_url),placeholderImage: #imageLiteral(resourceName: "default_herald"))
                cell.CarouselFigure.addSubview(figureImage)
            }
            return cell
        }
    }
    
    private func createSectionModel(_ figureList: [CarouselFigureModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: [figureList])]
    }
    
    private func layoutSubViews() {
        /*
         *To Fix
         */
//        if let navigationController = self.navigationController as? MainNavigationController{
//            print(screenRect)
//            homeTableView.frame = CGRect(x: 0,
//                                         y: navigationController.getHeight(),
//                                         width: screenRect.width,
//                                         height: screenRect.height - navigationController.getHeight())
//            homeTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
//        }
//        let navigationController = self.navigationController as! MainNavigationController

//        if let haha = self.tabBarController as? MainTabBarController{
//            print("hw")
//            if haha.navigationController == nil {
//                print("what")
//            }
//        }
            homeTableView.frame = CGRect(x: 0,
                                         y: 44,
                                         width: screenRect.width,
                                         height: screenRect.height - 44)
            homeTableView.top(44).left(0).right(0).bottom(0)
    }
}

