//
//  UserAccountVC.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/2/17.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit

class UserAccountVC: UIViewController, Router {

    @IBOutlet var notifySwitch: UISwitch!
    @IBOutlet var subscriptionPlan: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
        
    func initUI() {
        /// set title
        self.title = kAccount
        
        notifySwitch.isOn = isNotifyOn()
        notifySwitch.addTarget(self, action: #selector(notificationSettingChanged), for: .valueChanged);
        subscriptionPlan.text = AppSetting.shared.subscriptionDesc
        toggleUpgrade()
        
        let closeBtn = UIBarButtonItem(image: UIImage(named: "closeBtn"), style: .plain, target: self, action: #selector(PrivacyPolicyVC.closeScreen))
        navigationItem.leftBarButtonItem = closeBtn
    }
    
    @objc func notificationSettingChanged(_notificationSwitch: UISwitch!) {
        if _notificationSwitch.isOn {
            AppSetting.set("1", forKey: keyNotification)
            
            //disable push notification in app since not able to set server now,
            //should be remove when able to control backend
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            AppSetting.set("0", forKey: keyNotification)
            
            
            //disable push notification in app since not able to set server now,
            //should be remove when able to control backend
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    @IBAction func onUpgrade(_ sender: Any) {
        gotoPickPlan()
    }
    
    @objc func closeScreen() {
        self.navigationController?.dismiss(animated: true, completion:nil)
    }
    
    func toggleUpgrade() {
        if AppSetting.shared.isUnlocked {
            upgradeButton.setTitle("Status", for: .normal)
        }
        else {
            upgradeButton.setTitle("Upgrade", for: .normal)
        }
    }
    
    func isNotifyOn() -> Bool {
        
        let notifySetting = AppSetting.string(keyNotification)
        if notifySetting == kEmpty {
            return true
        }
        return notifySetting == "1" ? true : false
    }
}
