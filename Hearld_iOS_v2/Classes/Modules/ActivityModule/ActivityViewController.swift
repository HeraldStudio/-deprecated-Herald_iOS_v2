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
    
    var viewModel = ActivityViewModel()
    let bag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,ActivityModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityTableView)
        layoutSubviews()
        
        activityTableView.delegate = self
        activityTableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "Activity")
        setConfigureCell()
        
        viewModel.ActivityList.subscribe(
            onNext:{ activityArray in
                self.activityTableView.dataSource = nil
                Observable.just(self.createSectionModel(activityArray))
                    .bind(to: self.activityTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
            },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        //PrepareData
        viewModel.prepareData()
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Activity", for: indexPath) as! ActivityTableViewCell
            cell.titleLabel.text = item.title
            cell.stateLabel.text = item.start_time
            cell.picture.sd_setImage(with: URL(string: item.pic_url) , placeholderImage: #imageLiteral(resourceName: "default_herald"))
            cell.infoLabel.text = item.introduction
            return cell
        }
    }
    
    private func createSectionModel(_ activityList: [ActivityModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: activityList)]
    }
    
    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            activityTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            activityTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
