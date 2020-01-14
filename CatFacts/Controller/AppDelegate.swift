//
//  AppDelegate.swift
//  CatFacts
//
//  Created by Pae on 12/28/15.
//  Copyright © 2015 Pae. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var products: [SKProduct] = []
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        AppSetting.shared.isPushTapped = true
        
        //setup IAP configuration before open news articles screen
        self.setupIAP()
        PFPush.handle(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
                
        if GlobInfo.sharedInstance().objCurrentUser != nil {
            GlobInfo.sharedInstance().deviceTokenData = deviceToken;
            CatFactsApi.saveCurUserToInstallation()
        }
        else {
            GlobInfo.sharedInstance().deviceTokenData = deviceToken;
        }
    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        globalInit()
        UIApplication.shared.statusBarStyle = .lightContent
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        
        //set the delegate in didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self
        
        /*
        if let launchOptions = launchOptions as? [String : AnyObject] {
            if let notificationDictionary = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
                self.application(application, didReceiveRemoteNotification: notificationDictionary)
            }
        }*/
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK: - System Init
    
    func setupIAP () {
        
        let productIds = Set([weekProduct, yearProduct])
        IAP.requestProducts(productIds) { response, error in
            if let products = response?.products {
                self.products = products.sorted(by: { Float($0.price) < Float($1.price) })
                
                IAP.validateReceipt(sharedSecret, handler: { (statusCode, expireDate, _) in
                    if let expireDate = expireDate, expireDate.count > 0 {
                        expireDate.forEach({ productId, date in
                            if date >= Date()  {
                                AppSetting.shared.expiredDate = date
                                AppSetting.shared.isUnlocked = true
                                self.startApp()
                            }
                        })
                    } else {
                        self.startApp()
                    }
                })
            } else if let invalidProductIds = response?.invalidProductIdentifiers {
                print(invalidProductIds)
                self.startApp()
            } else {
                print(error?.localizedDescription)
                self.startApp()
            }
        }
    }
    
    func initParse() {
        
        ParseCrashReporting.enable();
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "uplifting-news-parse"
            $0.clientKey = nil
            $0.server = "http://uplifting-news-parse.herokuapp.com/parse/"
        }
        Parse.initialize(with: configuration)//*/
        GlobInfo.sharedInstance();
    }
    
    func gotoSignin() {
        
        let _storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let _vcRoot = _storyBoard.instantiateViewController(withIdentifier: "SignInVC")
        let _vcNav = UINavigationController(rootViewController: _vcRoot)
        
        _vcNav.interactivePopGestureRecognizer?.isEnabled = true
        _vcNav.interactivePopGestureRecognizer?.delegate = nil
        window?.rootViewController = _vcNav;
        
    }
    
    func gotoSignUp() {
        
        let _storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let _vcRoot = _storyBoard.instantiateViewController(withIdentifier: "SignUpVC")
        let _vcNav = UINavigationController(rootViewController: _vcRoot)
        
        _vcNav.interactivePopGestureRecognizer?.isEnabled = true
        _vcNav.interactivePopGestureRecognizer?.delegate = nil
        window?.rootViewController = _vcNav
    }
    
    func gotoMain() {
        
        let _storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var _viewMain:UIViewController?
        
        if (AppSetting.shared.isUnlocked) {
            _viewMain = _storyBoard.instantiateViewController(withIdentifier: "NewsArticlesVC")
        } else {
            _viewMain = _storyBoard.instantiateViewController(withIdentifier: "PickPlanVC")
        }

        var _viewNav:UINavigationController?
        _viewNav = UINavigationController(rootViewController: _viewMain!)
        
        _viewNav?.interactivePopGestureRecognizer?.isEnabled = true
        _viewNav?.interactivePopGestureRecognizer?.delegate = nil
        
        
        let menuVC = _storyBoard.instantiateViewController(withIdentifier: "MenuVC")
        let menuNavController = UINavigationController(rootViewController: menuVC)
        
        let mainRevealController:SWRevealViewController = SWRevealViewController(rearViewController: menuNavController, frontViewController: _viewNav)
        self.window?.rootViewController = mainRevealController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoPickPlan() {
         
         let _storyBoard = UIStoryboard(name: "Main", bundle: nil)
         var _viewMain:UIViewController?
         _viewMain = _storyBoard.instantiateViewController(withIdentifier: "PickPlanVC")

         var _viewNav:UINavigationController?
         _viewNav = UINavigationController(rootViewController: _viewMain!)
         
         _viewNav?.interactivePopGestureRecognizer?.isEnabled = true
         _viewNav?.interactivePopGestureRecognizer?.delegate = nil
         
         let menuVC = _storyBoard.instantiateViewController(withIdentifier: "MenuVC")
         let menuNavController = UINavigationController(rootViewController: menuVC)
         
         let mainRevealController:SWRevealViewController = SWRevealViewController(rearViewController: menuNavController, frontViewController: _viewNav)
         self.window?.rootViewController = mainRevealController
         self.window?.makeKeyAndVisible()
     }
    
    func globalInit() {
        
        self.initParse()
        self.initAppearance()
        self.setupIAP()
    }
    
    func initAppearance() {
        
        SVProgressHUD.setBackgroundColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        //SVProgressHUD.setInfoImage(UIImage())
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 13.0))
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 72/255.0, green: 122/255.0, blue: 172/255.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 20.0)!]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    func startApp() {
        
        if (GlobInfo.sharedInstance().isLoggedIn() == true) {
            self.gotoMain()
        } else {
            self.gotoSignin()
        }
    }
}

        
        
        
        
        
        


