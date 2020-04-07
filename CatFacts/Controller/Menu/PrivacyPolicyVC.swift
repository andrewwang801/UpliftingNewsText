//
//  PrivacyPolicyVC.swift
//  CatFacts
//
//  Created by Work on 15/04/2016.
//  Copyright © 2016 Pae. All rights reserved.
//

import UIKit


class PrivacyPolicyVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var screenId:Int = 0

    /*
     func closeScreen() {
     self.dismissViewControllerAnimated(true, completion:nil)
     }*/

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         let closeBtn = UIBarButtonItem(image: UIImage(named: "closeBtn"), style: .Plain, target: self, action: "closeScreen")
         navigationItem.then {
         $0.leftBarButtonItem = closeBtn
         }*/

        let closeBtn = UIBarButtonItem(image: UIImage(named: "closeBtn"), style: .plain, target: self, action: #selector(PrivacyPolicyVC.closeScreen))
        navigationItem.leftBarButtonItem = closeBtn

        var titleStr:String = "", fileName:String = ""
        var attributedString : NSMutableAttributedString = NSMutableAttributedString(string: kEmpty)
        
        if screenId == 0 {
            titleStr = "Privacy Policy";
            fileName = "UpliftingNewsPrivacyPolicy";
            attributedString = getAttrStringFromRTF(fileName: fileName)
        }
        else if screenId == 1 {
            titleStr = "Terms of Service";
            fileName = "UpliftingNewsTermsOfService";
            attributedString = getAttrStringFromRTF(fileName: fileName)
        }
        else if screenId == 2 {
            titleStr = "About";
            fileName = "UpliftingNewsAbout";
            attributedString = getAttrStringFromRTF(fileName: fileName)
        }
        else if screenId == 3 {
            titleStr = "Help";
            fileName = "UpliftingNewsHelp";
            attributedString = getAttrStringDyn(stringArray: kHelpTexts, fontSize: 17.0)
        }
        else if screenId == 4 {
            titleStr = "FAQ";
            fileName = "UpliftingNewsFAQ";
            attributedString = getAttrStringDyn(stringArray: kFaqTexts, fontSize: 17.0)
        }

        self.navigationItem.title = titleStr

        self.textView.text = ""
        self.textView.attributedText = attributedString
        self.textView.contentOffset = CGPoint(x: 10, y: 10)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.textView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textView.isScrollEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func closeScreen() {
        self.navigationController?.dismiss(animated: true, completion:nil)
    }
}

extension PrivacyPolicyVC {
    func getAttrStringDyn(stringArray: [String] = [], fontSize: CGFloat) -> NSMutableAttributedString {
        var boldFont:UIFont{return UIFont.boldSystemFont(ofSize: fontSize)}
        var normalFont:UIFont {return UIFont.systemFont(ofSize: fontSize)}
        var attributedString = NSMutableAttributedString(string: kEmpty)
        for (index, item) in stringArray.enumerated() {
            if (index + 1) % 2 == 1 {
                let attributes: [NSMutableAttributedString.Key : Any] = [.font : boldFont]
                attributedString.append(NSMutableAttributedString(string: item, attributes: attributes))
                attributedString.append(NSMutableAttributedString(string: "\n", attributes: attributes))
            }
            else {
                let attributes: [NSMutableAttributedString.Key : Any] = [.font : normalFont]
                attributedString.append(NSMutableAttributedString(string: item, attributes: attributes))
                attributedString.append(NSMutableAttributedString(string: "\n\n", attributes: attributes))
            }
        }
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func getAttrStringFromRTF(fileName: String) -> NSMutableAttributedString {
        let rtf = Bundle.main.url(forResource: fileName, withExtension: "rtf", subdirectory: nil, localization: nil)
        let attributedString : NSMutableAttributedString
        do {
            try attributedString = NSMutableAttributedString(fileURL: rtf!, options: [NSAttributedString.DocumentAttributeKey.documentType:NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        }
        catch {
            attributedString = NSMutableAttributedString(string: "")
        }
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0), range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}
