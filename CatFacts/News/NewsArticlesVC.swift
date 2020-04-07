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

class NewsArticlesVC: UITableViewController, Router {
    
    private var notificationButton: UIBarButtonItem!
    var items = [NewsArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            let sideMenuButton = UIBarButtonItem(image: UIImage(named: "RevealMenu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.leftBarButtonItem = sideMenuButton
        }
        let accountButton = UIBarButtonItem(image: itemImage(name: "userAccount")?.imageWithColor(color: UIColor.white), style: .plain, target: self, action: #selector(self.gotoUserAccount(_:)))
        navigationItem.rightBarButtonItem = accountButton

        self.tableView.showAnimatedSkeleton()
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
        initData()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationItem.title = "Uplifting News"
    }
    
    @objc func onBackPressed(_ sender:AnyObject?){
        dismiss(animated: true)
    }
    
    @objc func gotoUserAccount(_ sender: AnyObject?) {
        gotoAccountPreference()
    }
    
    func initData() {
        items.removeAll()
    }
    
    func initUI() {
    }
    
    
    func loadNewsArticlesFromPushNotification() {
        APIManager.doNormalRequest(baseURL: kPushAPIEndPoint, methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert(kInternetConnectionErr, withTitle: kInternetConnectionTitle, action: { UIAlertAction in
                    self.loadNewsArticlesFromPushNotification()
                })
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
                    CommData.showAlert(kDataParseErr, withTitle: kDataParseErr, action: nil)
                }
            }
        }
    }
    
    func loadNewsArticlesForSubscribers(after: String = "") {
        var ApiEndPoint = kSubscribedAPIEndPoint
        if after != kEmpty {
            ApiEndPoint += "&after=" + after
        }
        APIManager.doNormalRequest(baseURL: ApiEndPoint, methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert(kInternetConnectionErr, withTitle: kInternetConnectionTitle, action: { UIAlertAction in
                    self.loadNewsArticlesForSubscribers()
                })
            }
            else {
                do {
                    let json = try JSON(data: response as! Data)
                    self.items.append(contentsOf: NewsArticle.fromToArr(json: json))
                    
                    if json["data"]["after"].stringValue != kEmpty {
                        self.loadNewsArticlesForSubscribers(after: json["data"]["after"].stringValue)
                    }
                    self.setupTableView()
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                    CommData.showAlert(kDataParseErr, withTitle: kDataParseErr, action: nil)
                }
            }
        }
    }
    
    
    func loadNewsArticlesForFreePlan() {
        
        APIManager.doNormalRequest(baseURL: kFreeAPIEndPoint, methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                CommData.showAlert("Check internet connection and try again", withTitle: "Network Error!", action: { UIAlertAction in
                    self.loadNewsArticlesForFreePlan()
                })
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
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open in safari
//        guard let url = URL(string: items[indexPath.section].url) else { return }
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
        
        let newsArticleDetailVC = UIViewController.getViewController(storyboardName: "Main", storyboardID: "newsArticleDetailVC") as! NewsArticleDetailVC
        newsArticleDetailVC.strURL = items[indexPath.section].url
        self.navigationController?.pushViewController(newsArticleDetailVC, animated: true)
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
