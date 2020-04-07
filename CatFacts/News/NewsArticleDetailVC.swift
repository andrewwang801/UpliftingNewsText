//
//  NewsArticleDetailVC.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/7.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit
import WebKit

class NewsArticleDetailVC: UIViewController, WKNavigationDelegate, Router {
    
    @IBOutlet var webView: WKWebView!
    
    var strURL: String = ""
    private var estimatedProgressObserver: NSKeyValueObservation?
    let progressView = UIProgressView(progressViewStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        loadWebPage()
        initWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        progressView.isHidden = true
    }
    
    func initUI() {
        
        if AppSetting.string(kWidget) == "1" {
            
            let homeBtn = UIBarButtonItem(image: itemImage(name: "home")?.imageWithColor(color: .white), style: .plain, target: self, action: #selector(gotoHome(_:)))
            navigationItem.leftBarButtonItem = homeBtn
            
            AppSetting.set("0", forKey: kWidget)
        }
        navigationController?.navigationBar.topItem?.title = kEmpty
        self.title = kNewsArticle
        let shareBtn = UIBarButtonItem(image: itemImage(name: "share")?.imageWithColor(color: .white), style: .plain, target: self, action: #selector(share(_:)))
        navigationItem.rightBarButtonItem = shareBtn
        

    }
    
    func loadWebPage() {
        
        //load using webview
        guard let url = URL(string: strURL) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func initWebView() {
        
        //set progressview
        setupProgressView()
        setupEstimatedProgressObserver()
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)

        progressView.isHidden = true

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),

            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4.0)
        ])
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func gotoHome(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.gotoMain()
    }
    
    @objc func share(_ sender: AnyObject) {
        
        var items:[Any] = [Any]()
        
        //share text
        items.append(strURL)
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
}

extension NewsArticleDetailVC {
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        
        if progressView.isHidden {
            // Make sure our animation is visible.
            progressView.isHidden = false
        }

        UIView.animate(withDuration: 0.33,
                       animations: {
                           self.progressView.alpha = 1.0
        })
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33,
                       animations: {
                           self.progressView.alpha = 0.0
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completly finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.progressView.isHidden = isFinished
        })
    }
}
