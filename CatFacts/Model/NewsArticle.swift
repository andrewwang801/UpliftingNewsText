//
//  NewsArticle.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/8.
//  Copyright © 2020 Pae. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsArticle {
    var title = ""
    var selftext = ""
    var thumbnail = ""
    var url = ""
    var domain = ""
    
    static func fromToArr(json: JSON) -> [NewsArticle] {
        
        var newsArticleArr: [NewsArticle] = []

        for news in json["data"]["children"].arrayValue {
            if news["data"]["selftext"].string != "" {
                continue
            }
            guard let title = news["data"]["title"].string,
                let thumbnail = news["data"]["thumbnail"].string,
                let domain = news["data"]["domain"].string,
                let url = news["data"]["url"].string  else { continue }
            let newsArticle = NewsArticle()
            newsArticle.title = title
            newsArticle.thumbnail = thumbnail
            newsArticle.url = url
            newsArticle.domain = domain
            newsArticleArr.append(newsArticle)
        }
        return newsArticleArr
    }
}
