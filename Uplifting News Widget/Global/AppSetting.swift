//
//  AppSetting.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/7.
//  Copyright © 2020 Pae. All rights reserved.
//

import Foundation

class AppSetting {
    
    static var shared: AppSetting {
        if gbInstance == nil {
            gbInstance = AppSetting()
            return gbInstance!
        }
        return gbInstance!
    }
    
    //InApp purchase
    var expiredDate: Date?
    var productId: String?
    var isUnlocked = false
    
    //push notification tapped
    var isPushTapped = false
    
    //subscription detail
    var subscriptionDesc = ""

    public static func string(_ forKey: String, default:String = "") -> String {
        return UserDefaults.standard.string(forKey: forKey) ?? `default`
    }
    
    public static func set(_ value:String, forKey:String){
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    // UserDefaults for AppGroup
    public static func setGroup(_ value: String, forKey: String){
        let defaults = UserDefaults(suiteName: "group.upliftingnews")
        defaults?.set(value, forKey: forKey)
    }
    
    public static func stringGroup(forKey: String) -> String{
        let defaults = UserDefaults(suiteName: "group.upliftingnews")
        return defaults?.string(forKey: forKey) ?? ""
    }
}
var gbInstance: AppSetting?
