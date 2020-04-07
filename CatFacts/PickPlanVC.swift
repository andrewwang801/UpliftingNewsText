//
//  PickPlanVC.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/6.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import IBAnimatable

class PickPlanVC: UIViewController , MFMailComposeViewControllerDelegate, Router{
    
    @IBOutlet var freePlanView: AnimatableView!
    @IBOutlet var monthlyPlanView: AnimatableView!
    @IBOutlet var yearlyPlanView: AnimatableView!
    @IBOutlet weak var restoreButton: AnimatableButton!
    
    @IBOutlet var pickAPlanLabel: UILabel!
    @IBOutlet var planLabel: UILabel!
    @IBOutlet var subscriptionLabel: UILabel!
    
    @IBOutlet weak var faqHeadLabel: UILabel!
    @IBOutlet weak var faqLabel: UIButton!
    
    var fromMenu: Int = 0
    let normalBackgroudColor: UIColor = UIColor(red: 73, green: 123 , blue: 177, alpha: 1)
    let checkedBackgroundColor: UIColor = UIColor(red: 242, green: 242 , blue: 247, alpha: 1)
    let normalTextColor: UIColor = UIColor.white
    let checkedTextColor: UIColor = UIColor(red: 73/255, green: 123/255 , blue: 177/255, alpha: 1)
    
    // MARK View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromMenu == 1 {
            let closeBtn = UIBarButtonItem(image: UIImage(named: "closeBtn"), style: .plain, target: self, action: #selector(PickPlanVC.closeScreen))
            navigationItem.leftBarButtonItem = closeBtn
        }
        let helpBtnImage = itemImage(name: "helpBtn")
        let helpBtn = UIBarButtonItem(image: helpBtnImage, style: .plain, target: self, action: #selector(PickPlanVC.helpScreen))
        navigationItem.rightBarButtonItem = helpBtn
        navigationItem.title = Utils.setTitle()
        setupEvent()
        self.updateUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK IBActions
    @IBAction func onFAQ(_ sender: Any) {
        gotoPrivacyPolicy(screenId: 4)
    }
    
    @IBAction func onContactSupport(_ sender: Any) {
        goToContactSupport()
    }
    
    @objc func onFree(_ sender: Any) {
        
        Utils.setSubscriptionDesc(productId: kFree)
        self.gotoNewsArticles(sender: nil)
    }
    
    @objc func onMonthly(_ sender: Any) {
        
        //do subscribe
        SVProgressHUD.show(withStatus: "Please wait...")
        IAP.purchaseProduct(monthProduct) { productId, error in
            if let _ = productId {
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        expireDate?.forEach({ productId, date in
                            
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                Utils.setSubscriptionDesc(productId: productId)
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
    
    @objc func onYearly(_ sender: Any) {
        
        //do subscribe 
        SVProgressHUD.show(withStatus: "Please wait...")
        IAP.purchaseProduct(yearProduct) { productId, error in
            if let _ = productId {
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        expireDate?.forEach({ productId, date in
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                Utils.setSubscriptionDesc(productId: productId)
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
    
    @IBAction func onRestore(_ sender: Any) {
        SVProgressHUD.show()
        IAP.restorePurchases { productIds, error in
            if productIds.count > 0 {
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        expireDate?.forEach({ productId, date in
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                Utils.setSubscriptionDesc(productId: productId)
                                self.updateUI()
                            }
                        })
                    }
                })
                AppSetting.shared.isUnlocked = true
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setupEvent() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(onFree(_:)))
        freePlanView.addGestureRecognizer(tapGesture)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onMonthly(_:)))
        monthlyPlanView.addGestureRecognizer(tapGesture)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onYearly(_:)))
        yearlyPlanView.addGestureRecognizer(tapGesture)
    }
    
    func updateUI() {
        
        if let date = AppSetting.shared.expiredDate {
            let strDate = date.toDateString(format: "MMM dd, yyyy")
            subscriptionLabel.text = "Current subscription will be renewed\non \(strDate ?? "")"
        }
        
        if AppSetting.shared.isUnlocked {
            [pickAPlanLabel, freePlanView, monthlyPlanView, yearlyPlanView, restoreButton].forEach {
                $0?.isHidden = true
            }
            restoreButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
            subscriptionLabel.isHidden = false
            planLabel.isHidden = false
            self.navigationItem.title = Utils.setTitle()
        } else {
            [pickAPlanLabel, freePlanView, monthlyPlanView, yearlyPlanView, restoreButton].forEach { $0?.isHidden = false }
            restoreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            subscriptionLabel.isHidden = true
            planLabel.isHidden = true

            if (fromMenu == 1) {
                freePlanView.isHidden = true
                subscriptionLabel.text = kSubscriptionDesc
                subscriptionLabel.isHidden = false
                self.navigationItem.title = kUpgradePlan
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeScreen() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func helpScreen() {
        gotoPrivacyPolicy(screenId: 4)
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
}

