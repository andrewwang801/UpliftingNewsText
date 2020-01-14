//
//  PickPlanVC.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/6.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit
import StoreKit

let sharedSecret = "43db59f4a947459bb024f784f886ef46"
let weekProduct = "com.mjmupliftingnews.subscriptionmonth"
let yearProduct = "com.mjmupliftingnews.subscriptionyearly"

class PickPlanVC: UIViewController {
    
    @IBOutlet var freePlanView: CardView!
    @IBOutlet var monthlyPlanView: CardView!
    @IBOutlet var yearlyPlanView: CardView!
    
    @IBOutlet var pickAPlanLabel: UILabel!
    @IBOutlet var planLabel: UILabel!
    @IBOutlet var subscriptionLabel: UILabel!
    
    var fromMenu: Int = 0
    let normalBackgroudColor: UIColor = UIColor(red: 73, green: 123 , blue: 177, alpha: 1)
    let checkedBackgroundColor: UIColor = UIColor(red: 242, green: 242 , blue: 247, alpha: 1)
    let normalTextColor: UIColor = UIColor.white
    let checkedTextColor: UIColor = UIColor(red: 73/255, green: 123/255 , blue: 177/255, alpha: 1)
    
    @IBAction func onFree(_ sender: Any) {
        self.gotoNewsArticles(sender: nil)
    }
    
    @IBAction func onMonthly(_ sender: Any) {
        
        //do subscribe
        SVProgressHUD.show(withStatus: "Please wait...")
        IAP.purchaseProduct(weekProduct) { productId, error in
            if let _ = productId {
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        expireDate?.forEach({ productId, date in
                            
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                self.updateUI()
                                self.gotoNewsArticles(sender: nil)
                            }
                        })
                    }
                })
                
                AppSetting.shared.isUnlocked = true
            } else if let error = error {
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func onYearly(_ sender: Any) {
        
        //do subscribe 
        SVProgressHUD.show(withStatus: "Please wait..")
        IAP.purchaseProduct(yearProduct) { productId, error in
            if let _ = productId {
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        expireDate?.forEach({ productId, date in
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                self.updateUI()
                                self.gotoNewsArticles(sender: nil)
                            }
                        })
                    }
                })
                
                AppSetting.shared.isUnlocked = true
            } else if let error = error {
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func closeScreen() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func gotoNewsArticles(sender: AnyObject?) {
        
        let _storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let _vcRoot = _storyBoard.instantiateViewController(withIdentifier: "NewsArticlesVC")
        let _vcNav = UINavigationController(rootViewController: _vcRoot)
        
        _vcNav.interactivePopGestureRecognizer?.isEnabled = true
        _vcNav.interactivePopGestureRecognizer?.delegate = nil
        
        let menuVC = _storyBoard.instantiateViewController(withIdentifier: "MenuVC")
        let menuNavController = UINavigationController(rootViewController: menuVC)
        
        let mainRevealController:SWRevealViewController = SWRevealViewController(rearViewController: menuNavController, frontViewController: _vcNav)
        UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (fromMenu == 1) {
            let closeBtn = UIBarButtonItem(image: UIImage(named: "closeBtn"), style: .plain, target: self, action: #selector(PickPlanVC.closeScreen))
            navigationItem.leftBarButtonItem = closeBtn
            
            if !AppSetting.shared.isUnlocked {
                freePlanView.isHidden = true
                subscriptionLabel.text = "You are using Free plan. Please subscribe for more features."
                subscriptionLabel.isHidden = false
            }
        }
        
        //update ui according to subscription
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func updateUI() {
        
        if let date = AppSetting.shared.expiredDate {
            let strDate = date.toDateString(format: "MMM dd, yyyy")
            subscriptionLabel.text = "Current subscription will be renewed\nat \(strDate)"
        }
        
        if AppSetting.shared.isUnlocked {
            [pickAPlanLabel, freePlanView, monthlyPlanView, yearlyPlanView].forEach { $0?.isHidden = true }
            subscriptionLabel.isHidden = false
        } else {
            [pickAPlanLabel, freePlanView, monthlyPlanView, yearlyPlanView].forEach { $0?.isHidden = false }
            subscriptionLabel.isHidden = true
        }
    }
}

