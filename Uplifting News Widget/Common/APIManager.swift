//
//  APIManager.swift
//  iRis
//
//  Created by iOS Developer on 6/29/16.
//  Copyright © 2016 Q-Scope. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {

    static let kSMSServerURL = "http://api.smsbroadcast.com.au"

    static func doNormalRequest(baseURL: String, methodName: String, httpMethod: String, params: [String: Any], shouldShowHUD: Bool, completion: @escaping (Any?, String) -> Void) {
        
        NSLog("methodName: \(methodName), params: \(params)")
        
        let apiURL = "\(baseURL)\(methodName)"
        let _method: HTTPMethod = httpMethod == "POST" ? HTTPMethod.post : HTTPMethod.get
        
        Alamofire.request("\(apiURL)", method: _method, parameters: params)
        .validate()
        .responseJSON { response in
            guard response.result.isSuccess else {
                NSLog("Response error: \(response.result.error!)")
                let errorDesc = response.result.error!.localizedDescription ?? ""
                completion(nil, errorDesc)
                return
            }
            guard let responseData = response.data else {
                NSLog("Invalid response: \(response.result.error!)")
                let errorDesc = response.result.error!.localizedDescription ?? ""
                completion(nil, errorDesc)
                return
            }
            // Log.debug("response: \(responseData)")
            completion(responseData, "")
            return
        }
    }

    static func doNormalRequest(baseURL: String, methodName: String, httpMethod: String, headers: [String: String], params: [String: Any], shouldShowHUD: Bool, completion: @escaping (Any?, String) -> Void) {

        NSLog("methodName: \(methodName), param: \(params)")


        let apiURL = "\(baseURL)\(methodName)"
        let _method: HTTPMethod = httpMethod == "POST" ? HTTPMethod.post : HTTPMethod.get

        Alamofire.request(apiURL, method: _method, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    NSLog("Response error: \(response.result.error!)")
                    completion(nil, "response error")
                    return
                }
                guard let responseData = response.data else {
                    NSLog("Invalid response: \(response.result.error!)")
                    completion(nil, "response error")
                    return
                }
                completion(responseData, "")
                return
        }
    }

   
    static func getBasicCredential(userName: String, password: String) -> String {
        let credentialData = "\(userName):\(password)".data(using: .utf8)
        let base64Credentials = credentialData!.base64EncodedString()
        return "Basic \(base64Credentials)"
    }

    // MARK: -- background manager --
    static let backgroundManager: Alamofire.SessionManager = {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier + ".background"))
    }()

}
