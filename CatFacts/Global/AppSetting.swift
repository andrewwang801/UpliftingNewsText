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
    
    var expiredDate: Date?
    var isUnlocked = false
    var isPushTapped = false
    
    enum SubscriptionID: String {
        case none = "0"
        case free = "1"
        case monthly = "2"
        case yearly = "3"
    }
    
    static var subscription = SubscriptionID(rawValue: string("app_subscription")) ?? .none {
        didSet {
            set(subscription.rawValue, forKey: "app_subscription")
        }
    }
    
    private static func string(_ forKey: String, default:String = "") -> String {
        return UserDefaults.standard.string(forKey: forKey) ?? `default`
    }
    
    private static func set(_ value:String, forKey:String){
        UserDefaults.standard.set(value, forKey: forKey)
    }
}
var gbInstance: AppSetting?
