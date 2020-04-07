//
//  AdsListVC.swift
//  Alaitisal
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019 JN. All rights reserved.
//
import UIKit
import NotificationCenter
import SwiftyJSON
import SkeletonView
import JSQDataSourcesKit

class TodayViewController: UITableViewController, NCWidgetProviding {

    
    private var notificationButton: UIBarButtonItem!
    var items = [NewsArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width:self.view.frame.size.width, height: 96 * 6)
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }

        loadNewsArcitles()
        initUI()
    }
    
    func loadNewsArcitles() {
        
        switch AppSetting.stringGroup(forKey: "plan") {
        case "free":
            loadNewsArticlesForFreePlan()
            break
        default:
            loadNewsArticlesForSubscribers()
            break
        }
    }
    
    @available(iOS 10.0, *)
       @available(iOSApplicationExtension 10.0, *)
       func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
           if activeDisplayMode == .expanded {
               self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 96 * 6)
           }else if activeDisplayMode == .compact{
               self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
           }
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
    
    func loadNewsArticlesForFreePlan() {
        
        APIManager.doNormalRequest(baseURL: "https://old.reddit.com/r/UpliftingNews/.json?limit=10", methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
            }
            else {
                let json = JSON(data: response as! Data)
                self.items = NewsArticle.fromToArr(json: json)
                self.setupTableView()
                self.tableView.reloadData()
            }
        }
    }
    
    func loadNewsArticlesForSubscribers() {
        APIManager.doNormalRequest(baseURL: "https://old.reddit.com/r/UpliftingNews/top/.json?sort=new", methodName: "", httpMethod: "GET", headers: [:], params: [:], shouldShowHUD: false) { (response, message) in
            if response == nil {
                self.loadNewsArticlesForSubscribers()
            }
            else {
                let json = JSON(data: response as! Data)
                self.items = NewsArticle.fromToArr(json: json)
                self.setupTableView()
                self.tableView.hideSkeleton()
                self.tableView.reloadData()
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
        self.tableView.dataSource = dataSourceProvider?.tableViewDataSource
        self.tableView.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: "open://" + items[indexPath.section].url)
        {
            AppSetting.setGroup(items[indexPath.section].url, forKey: "url")
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }
    
}

extension TodayViewController : SkeletonTableViewDataSource {

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NewsArticleCell"
    }
}
