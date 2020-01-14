//
//  AdsListVC.swift
//  Alaitisal
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019 JN. All rights reserved.
//
import UIKit
import SwiftyJSON
import JSQDataSourcesKit
import SkeletonView

class NewsArticlesVC: UITableViewController {

    
    private var notificationButton: UIBarButtonItem!
    var items = [NewsArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            let sideMenuButton = UIBarButtonItem(image: UIImage(named: "RevealMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.leftBarButtonItem = sideMenuButton
        }

        tableView.showAnimatedSkeleton()
        if AppSetting.shared.isPushTapped {
            loadNewsArticlesFromPushNotification()
            AppSetting.shared.isPushTapped = false
        }
        else if !AppSetting.shared.isUnlocked {
            loadNewsArticlesForFreePlan()
        }
        else {
            loadNewsArticlesForSubscribers()
        }
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationItem.title = "News Articles"
    }
    @objc func onBackPressed(_ sender:AnyObject?){
        dismiss(animated: true)
    }
    
    func initUI() {
    }
    
    func loadNewsArticlesFromPushNotification() {
        APIManager.doNormalRequest(baseURL: "https://old.reddit.com/r/UpliftingNews/.json", methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert("Check internet connection and try again", withTitle: "Network Error!", action: nil)
            }
            else {
                do {
                    let json = try JSON(data: response as! Data)
                    self.items = NewsArticle.fromToArr(json: json)
                    self.setupTableView()
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                    CommData.showAlert("Data Parse Error!", withTitle: "Data Parse Error!", action: nil)
                }
            }
        }
    }
    
    func loadNewsArticlesForSubscribers() {
        APIManager.doNormalRequest(baseURL: "https://old.reddit.com/r/UpliftingNews/.json", methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert("Check internet connection and try again", withTitle: "Network Error!", action: nil)
            }
            else {
                do {
                    let json = try JSON(data: response as! Data)
                    self.items = NewsArticle.fromToArr(json: json)
                    self.setupTableView()
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                    CommData.showAlert("Data Parse Error!", withTitle: "Data Parse Error!", action: nil)
                }
            }
        }
    }
    
    
    func loadNewsArticlesForFreePlan() {
        
        APIManager.doNormalRequest(baseURL: "https://old.reddit.com/r/UpliftingNews/.json?limit=10", methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert("Check internet connection and try again", withTitle: "Network Error!", action: nil)
            }
            else {
                do {
                    let json = try JSON(data: response as! Data)
                    self.items = NewsArticle.fromToArr(json: json)
                    self.setupTableView()
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                    CommData.showAlert("Data Parse Error!", withTitle: "Data Parse Error!", action: nil)
                }
            }
        }
    }
    
    typealias CellConfig = ReusableViewConfig<NewsArticle, NewsArticleCell>
    var dataSourceProvider: DataSourceProvider<DataSource<NewsArticle>, CellConfig, CellConfig>?
    
    func setupTableView() {
//        var sectionList = [Section<NewsArticle>]()
//        let section: Section<NewsArticle> = Section(items)
//        sectionList.append(section)
        
        var sectionList = [Section<NewsArticle>]()
        for item in items {
            let section = Section(items:item)
            sectionList.append(section)
        }
        //let dataSource = DataSource(sections: sectionList)
        let dataSource = DataSource(sectionList)
        let cellConfig = ReusableViewConfig { (cell, info:NewsArticle?,  _, tableView, ip) -> NewsArticleCell in
            
            cell.item = info
            return cell
        }
        dataSourceProvider = DataSourceProvider(dataSource: dataSource, cellConfig: cellConfig, supplementaryConfig: cellConfig)
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: items[indexPath.section].url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension NewsArticlesVC : SkeletonTableViewDataSource {

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NewsArticleCell"
    }
}
