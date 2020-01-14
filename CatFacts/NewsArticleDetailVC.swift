//
//  NewsArticleDetailVC.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/7.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit

class NewsArticleDetailVC: UIViewController {
    
    var newsArticle = NewsArticle()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        title = "Print User Detail"
    }
    
    @objc func onBackPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    func refreshData() {
    }
}
