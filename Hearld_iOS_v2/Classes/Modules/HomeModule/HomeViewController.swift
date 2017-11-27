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
            cell.itemArray = item
            let pictureFrame = cell.CarouselFigure.bounds
            cell.pictureFrame = pictureFrame

            // 设置循环轮播图的contentSize
            cell.CarouselFigure.contentSize = CGSize(width: pictureFrame.size.width * CGFloat(item.count + 2),
                                                     height: pictureFrame.size.height)
            // 将index为count的图片增加到第一个
            let firstFigureImage = UIImageView()
            firstFigureImage.frame = CGRect(x: 0,
                                       y: 0,
                                       width: pictureFrame.size.width,
                                       height: pictureFrame.size.height)
            firstFigureImage.contentMode = .scaleToFill
            firstFigureImage.sd_setImage(with: URL(string: item[item.count - 1].picture_url), placeholderImage: #imageLiteral(resourceName: "default_herald"))
            cell.CarouselFigure.addSubview(firstFigureImage)
            
            // 正常内容的轮播图片
            for index in 0..<item.count{
                let figureImage = UIImageView()
                figureImage.frame = CGRect(x: pictureFrame.size.width * CGFloat(index + 1),
                                           y: 0,
                                           width: pictureFrame.size.width,
                                           height: pictureFrame.size.height)
                figureImage.contentMode = .scaleToFill
                figureImage.sd_setImage(with: URL(string: item[index].picture_url),placeholderImage: #imageLiteral(resourceName: "default_herald"))
                cell.CarouselFigure.addSubview(figureImage)
            }
            
            // 将index为0的图片增加到最后一个
            let lastFigureImage = UIImageView()
            lastFigureImage.frame = CGRect(x: pictureFrame.size.width * CGFloat(item.count + 1),
                                            y: 0,
                                            width: pictureFrame.size.width,
                                            height: pictureFrame.size.height)
            lastFigureImage.contentMode = .scaleToFill
            lastFigureImage.sd_setImage(with: URL(string: item[0].picture_url),placeholderImage: #imageLiteral(resourceName: "default_herald"))
            cell.CarouselFigure.addSubview(lastFigureImage)
            
            // 设置初始contentOffset并启动自动循环
            cell.CarouselFigure.contentOffset.x = pictureFrame.size.width
            cell.startAutoScroll()
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

