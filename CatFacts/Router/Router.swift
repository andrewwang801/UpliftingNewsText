//
//  Router.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/17.
//  Copyright © 2020 Pae. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol Router : MFMailComposeViewControllerDelegate  {}

extension Router where Self: UIViewController{
    private func _showNavigationVCReturn (storyboardName: String, storyboardID: String) {
        let vc = UIViewController.getViewController(storyboardName: storyboardName, storyboardID: storyboardID)
        let ctrl = UINavigationController(rootViewController: vc )
        ctrl.setDefaultModalPresentationStyle()
        present(ctrl, animated: true)
    }
    
    func gotoPrivacyPolicy(screenId: Int) {
        let privacyVC = UIViewController.getViewController(storyboardName: "Main", storyboardID: "PrivacyPolicyVC") as! PrivacyPolicyVC
        privacyVC.screenId = screenId
        let ctrl = UINavigationController(rootViewController: privacyVC)
        ctrl.setDefaultModalPresentationStyle()
        present(ctrl, animated: true)
    }
    
    func gotoNewsArticles() {
        let privacyVC = UIViewController.getViewController(storyboardName: "Main", storyboardID: "NewsArticlesVC") as! NewsArticlesVC
        let ctrl = UINavigationController(rootViewController: privacyVC)
        show(ctrl, sender: nil)
    }
  
    func gotoAccountPreference() {
        let accountVC = UIViewController.getViewController(storyboardName: "Main", storyboardID: "AccountPreferenceVC") as! UserAccountVC
        let ctrl = UINavigationController(rootViewController: accountVC)
        ctrl.modalPresentationStyle = .fullScreen
        ctrl.setDefaultModalPresentationStyle()
        present(ctrl, animated: true)
    }
    
    func gotoPickPlan() {
        let planVC = UIViewController.getViewController(storyboardName: "Main", storyboardID: "PickPlanVC") as! PickPlanVC
        planVC.fromMenu = 1
        let ctrl = UINavigationController(rootViewController: planVC)
        ctrl.setDefaultModalPresentationStyle()
        present(ctrl, animated: true)
    }
    
    //MARK: - Email Composer
    func goToContactSupport() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            mailComposeViewController.modalPresentationStyle = .fullScreen
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setToRecipients(["support@upliftingnewstexts.com"])
        mailComposerVC.setSubject("Feedback & Support")

        let email = ""
        let from = "From:      \(email)\n"
        let subject = "Subject:  Feedback & Support\n"
        let body = "Body:\n" + "                 Hi, I am having an issue with XXXXXXX feature.\n"

        let appVersion = Utils.getAppVersion()
        
        let planDesc = Utils.getSubscriptionDesc()
        
        let diagnostics = "\nDiagnostics:\n" + "App Version: \(appVersion)\n" + "Plan: \(planDesc)\n\n"
        let messageBody = from + subject + body + diagnostics
        mailComposerVC.setMessageBody(messageBody, isHTML: false)

        mailComposerVC.mailComposeDelegate = self

        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}
