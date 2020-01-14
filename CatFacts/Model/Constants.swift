//
//  Constants.swift
//  CatFacts
//
//  Created by Pae on 1/17/16.
//  Copyright © 2016 Pae. All rights reserved.
//

import Foundation

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

let AppStoreLink = "https://itunes.apple.com/app/id1074493881?mt=8"

let kPrimaryColor = UIColor(hex: 0x3F9DD9)
let kDeviceIsIPAD = UIDevice.current.userInterfaceIdiom == .pad

let kUUIDSignupPwd = "UUIDSignup"
let kUUIDSignedUpKey = "UUIDSignedUp"

let kChatServerId = "Server"
let kChatServerName = "Uplifting News Texts"
let kChatContactId = "Contact"

let kCreditPurchaseItems =
    [["name":"Credit Pack +10", "desc":"You could increase the credits by 10 for $0.99", "productId":"com.mjmupliftingnews.credit10", "increaseCredit":10, "price":"$0.99"],
    ["name":"Credit Pack +20", "desc":"You could increase the credits by 20 for $1.99", "productId":"com.mjmupliftingnews.credit20", "increaseCredit":20, "price":"$1.99"],
    ["name":"Credit Pack +30", "desc":"You could increase the credits by 30 for $2.99", "productId":"com.mjmupliftingnews.credit30", "increaseCredit":30, "price":"$2.99"],
    ["name":"Credit Pack +40", "desc":"You could increase the credits by 40 for $3.99", "productId":"com.mjmupliftingnews.credit40", "increaseCredit":40, "price":"$3.99"],
    ["name":"Credit Pack +50", "desc":"You could increase the credits by 50 for $4.99", "productId":"com.mjmupliftingnews.credit50", "increaseCredit":50, "price":"$4.99"],
    ["name":"Credit Pack +100", "desc":"You could increase the credits by 100 for $9.99", "productId":"com.mjmupliftingnews.credit100", "increaseCredit":100, "price":"$9.99"],
    ["name":"Credit Pack +200", "desc":"You could increase the credits by 200 for $19.99", "productId":"com.mjmupliftingnews.credit200", "increaseCredit":200, "price":"$19.99"],
    ["name":"Credit Pack +300", "desc":"You could increase the credits by 300 for $29.99", "productId":"com.mjmupliftingnews.credit300", "increaseCredit":300, "price":"$29.99"]]

let kContactStatusSendingColor = UIColor(red: 93.0/255, green: 190.0/255, blue: 113.0/255, alpha: 1.0)
let kContactStatusPausedColor = UIColor(red: 190.0/255, green: 166.0/255, blue: 93.0/255, alpha: 1.0)
let kContactStatusBlockedColor = UIColor(red: 190.0/255, green: 93.0/255, blue: 93.0/255, alpha: 1.0)

let kContactStatusColorArray = [kContactStatusSendingColor, kContactStatusPausedColor, kContactStatusBlockedColor]
let kContactStatusTextArray = ["Sending", "Paused", "Blocked"]
