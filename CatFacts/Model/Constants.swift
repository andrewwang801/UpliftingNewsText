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

let AppStoreLink = "https://apps.apple.com/us/app/uplifting-news/id1486710605?ls=1"

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

let sharedSecret = "43db59f4a947459bb024f784f886ef46"
let monthProduct = "com.mjmupliftingnews.subscriptionmonth"
let yearProduct = "com.mjmupliftingnews.subscriptionyearly"

let kMonthDesc = "Paid (monthly)"
let kAnnualDesc = "Paid (annually)"
let kFreeDesc = "Free"


//API EndPoints
let kFreeAPIEndPoint = "https://old.reddit.com/r/UpliftingNews/.json?limit=10"
let kSubscribedAPIEndPoint = "https://old.reddit.com/r/UpliftingNews/top/.json?sort=new"
let kPushAPIEndPoint = "https://old.reddit.com/r/UpliftingNews/new/.json?t=day"

//Messages
let kInternetConnectionErr = "Check internet connection and try again"
let kInternetConnectionTitle = "Network Error"
let kDataParseErr = "Data Parse Error"

let keyNotification = "notificationSetting"


//UserDefaults Keys
let kWidget = "widget"
let kPlan = "plan"

//UserDefaults constants
let kFree = "free"
let kMonth = "month"
let kYear = "year"

//Titles
let kNewsArticle = "News Article"
let kNewsArticles = "News Articles"
let kAccount = "Account"

let kPurchasedPlanMsg = "Status"
let kPickPlanMsg = "Pick a Plan"

//Empty
let kEmpty = ""

//AppGroup
let kAppGroup = "group.upliftingnews"
let kUpgradePlan = "Upgrade Plan"
let kSubscriptionDesc = "You are using the Free plan.\nUpgrade to premium for more features."

//FAQ Texts
let kFaqTexts = [
    "Q: Will this app provide me with positive news articles daily?",
    "A: Yes, on the Free plan, Uplifting News will provide you with up to 10 positive news articles daily.",

    "Q: Can I receive more than 10 articles per day?",
    "A: Yes, upgrading to a paid monthly or annual plan will allow you to view unlimited positive news articles per day.",

    "Q: Can I receive a discount if I pay annually?",
    "A: Yes, if you pay annually, you will receive a 20% discount.",

    "Q: What if I'm not satisfied, can I receive a refund?",
    "A: Yes, if you are not satisfied, please contact us using the Feedback & Support menu option and we will process your refund in a timely manner.",

    "Q: I need further help using the app. Do you provide support?",
    "A: Yes, please use the Feedback & Support menu option and we will reply to your request as soon as possible."
]

let kHelpTexts = [
 "Issue: The articles aren't appearing. What should I do?",
 "Solution: There may be a temporary loading issue with the article's remote server. Please simply close the app and re-open it. That should force a refresh. If you are still experiencing loading issues for one or more articles, you may have to wait and try again later because the news source's remote server might be down.",

 "Issue: I'm not receiving push notifications.",
 "Solution: Please make sure to allow push notifications in your device settings. This can be found by going to the Settings app > Notifications > scroll down to \"Uplifting News\" app > Toggle the \"Allow Notifications\" to the \"On\" position.",

 "Issue: I paid for a monthly or annual plan, but the credit wasn't applied. Can you help?",
 "Solution: Yes, absolutely. Please contact us via the \"Feedback & Support\" option in the menu and provide us with details about the plan you purchased that were not applied properly. In the details provided, please include:\n1.) Your email address that your account is associated with.\n2.) The plan you chose.\n3.) The approximate date of your purchase.\nThis will help us quickly locate your account and apply the corrections.",

 "Issue: I tried purchasing a paid monthly or annual plan, but nothing happened. What should I do?",
 "Solution: If the original purchase failed for some reason, please try again. You will not be double charged. You can also try completely closing (quitting) the app and re-opening to reset it. Then try processing your purchase again.",

 "Issue: I'm not satisfied. Can I have a refund?",
 "Solution: Absolutely. Please contact us via the \"Feedback & Support\" option in the menu and provide us with details about the plan you purchased and that you would like a refund. We will work to get your refund processed in a timely manner for you.",

 "Q: Will this app provide me with unlimited positive news articles daily?",
 "A: On the Free plan, Uplifting News will provide you with up to 10 positive news articles daily. On a paid monthly or annual plan, you can receive an unlimited amount of articles daily.",

 "Q: Can I receive more than 10 articles per day?",
 "A: Yes, upgrading to a paid monthly or annual plan will allow you to view unlimited positive news articles per day.",

 "Q: Can I receive a discount if I pay annually?",
 "A: Yes, if you pay annually, you will receive a 20% discount.",

 "Q: What if I'm not satisfied, can I receive a refund?",
 "A: Yes, if you are not satisfied, please contact us using the Feedback & Support menu option and we will process your refund in a timely manner.",

 "Q: I need further help using the app. Do you provide support?",
 "A: Yes, please use the Feedback & Support menu option and we will reply to your request as soon as possible."
]

