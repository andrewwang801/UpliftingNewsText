//
//  MenuVC.swift
//  CatFacts
//
//  Created by Work on 15/04/2016.
//  Copyright © 2016 Pae. All rights reserved.
//

import UIKit
import MessageUI

class MenuVC: UITableViewController, MFMailComposeViewControllerDelegate, Router {

    @IBOutlet var pickPlanLable: UILabel!
    @IBOutlet weak var pickPlanCell: UITableViewCell!
    
    enum TableRow {
        case account, plan, about, help, faq, feedbackAndSupport, rateThisApp, inviteFriends, visitOurWebsite, privacyPolicy, termsOfService

        init?(row: Int) {
            switch (row) {
            case 0:
                self = .account
            case 1:
                self = .plan
            case 2:
                self = .about
            case 3:
                self = .help
            case 4:
                self = .faq
            case 5:
                self = .feedbackAndSupport
            case 6:
                self = .rateThisApp
            case 7:
                self = .inviteFriends
            case 8:
                self = .visitOurWebsite
            case 9:
                self = .privacyPolicy
            case 10:
                self = .termsOfService
            default:
                return nil
            }
        }
    }

    //MARK: - Email Composer

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            CatFactsApi.reqMyContactList(nil) { (succeed, aArrResult) -> Void in
                DispatchQueue.main.async {
                    if (succeed) {
                        let mailComposeViewController = self.configuredMailComposeViewController(contactArray: aArrResult!)
                        mailComposeViewController.modalPresentationStyle = .fullScreen
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    }
                    else {
                        let loadContactErrorAlert = UIAlertView(title: "", message: "Could not get the contact data.", delegate: self, cancelButtonTitle: "OK")
                        loadContactErrorAlert.show()
                    }
                }
            }
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController(contactArray: NSArray) -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setToRecipients(["support@upliftingnewstexts.com"])
        mailComposerVC.setSubject("Feedback & Support")

        let email = ""
        let from = "From:      \(email)\n"
        let subject = "Subject:  Feedback & Support\n"
        let body = "Body:\n" + "                 Hi, I am having an issue with XXXXXXX feature.\n"

        let appVersion = Utils.getAppVersion()
        var creditCount = 0
        for contact in contactArray {
            let objContact = contact as! PFObject
            let credit = objContact["numberCredits"] as? Int ?? 0
            creditCount += credit
        }
        
        let planDesc = Utils.getSubscriptionDesc()
        
        let diagnostics = "Diagnostics:\n" + "App Version : \(appVersion)\n" + "Plan: \(planDesc)\n\n"
        let concludeStr = "Sincerely, \n\n" + "Matt McWillam"
        let messageBody = from + subject + body + diagnostics + concludeStr
        mailComposerVC.setMessageBody(messageBody, isHTML: false)

        mailComposerVC.mailComposeDelegate = self

        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.deselectSelectedIndexPath()
    }

    //MARK: - Methods

    func rateUs() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            if let appStoreURL = URL(string: AppStoreLink) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
        self.deselectSelectedIndexPath()
    }

    func inviteFriends() {
        let textToShare = ""
        if let appStoreURL = URL(string: AppStoreLink) {
            let objectsToShare = [textToShare, appStoreURL] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)

            self.deselectSelectedIndexPath()
        }
    }

    func likeUsOnFacebook() {
        let facebookURL = URL(string: "fb://profile/1054480257937006")!
        if UIApplication.shared.canOpenURL(facebookURL) {
            UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
        } else {
            if let fbURL = URL(string:"https://www.facebook.com/upliftingnewstexts/") {
                UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
            }
        }
        self.deselectSelectedIndexPath()
    }

    func followUsOnTwitter() {
        let twitterURL = URL(string: "twitter:///user?screen_name=upliftingnewstexts")!
        if UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        } else {
            if let url = URL(string: "https://twitter.com/upliftingnewstexts") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        self.deselectSelectedIndexPath()
    }

    func visitOurWebsite() {
        if let websiteURL = URL(string: "https://www.upliftingnewsapp.com/") {
            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
        }
        self.deselectSelectedIndexPath()
    }

    func privacyPolicy(screenId: Int) {
        if let privacyVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC {
            privacyVC.screenId = screenId

            let navController = UINavigationController(rootViewController: privacyVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func pickPlan() {
        if let pickPlanVC =  self.storyboard?.instantiateViewController(withIdentifier: "PickPlanVC") as? PickPlanVC {
            pickPlanVC.fromMenu = 1
            let navController = UINavigationController(rootViewController: pickPlanVC)
            navController.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
        }
    }
    
    func logout() {
        CatFactsApi.logout()
        Utils.setBoolSetting(key: kUUIDSignedUpKey, value: false)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.gotoSignin()
        }
    }

    //MARK: - TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (TableRow(row: indexPath.row)!) {
        case .about:
            self.privacyPolicy(screenId: 2)
            break
        case .help:
            self.privacyPolicy(screenId: 3)
            break
        case .faq:
            gotoPrivacyPolicy(screenId: 4)
            break
        case .feedbackAndSupport:
            goToContactSupport()
            break;
        case .rateThisApp:
            self.rateUs()
            break
        case .inviteFriends:
            self.inviteFriends()
            break
        case .visitOurWebsite:
            self.visitOurWebsite()
            break
        case .privacyPolicy:
            self.privacyPolicy(screenId: 0)
            break
        case .termsOfService:
            self.privacyPolicy(screenId: 1)
            break
        case .plan:
            self.pickPlan()
            break;
        case .account:
            gotoAccountPreference()
            break;
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func deselectSelectedIndexPath() {
        if let indexPath:IndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.deselectSelectedIndexPath()
    }

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickPlanLable.text = Utils.setTitle()
        
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 100
        }
        updatePlanCell()
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    func updatePlanCell() {
        if AppSetting.shared.isUnlocked {
            pickPlanCell.isHidden = true
            pickPlanLable.isHidden = true
            pickPlanCell.heightAnchor.constraint(equalToConstant: 0).isActive = true
            pickPlanLable.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        else {
            pickPlanCell.isHidden = false
            pickPlanLable.isHidden = false
            pickPlanLable.text = "Upgrade to Premium"
        }
    }
}
