//
//  NewsArticleCell.swift
//  CatFacts
//
//  Created by Apple Developer on 2020/1/7.
//  Copyright © 2020 Pae. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

class NewsArticleCell: UITableViewCell, ReusableView {

    @IBOutlet weak var newsArticleImage: UIImageView!
    @IBOutlet weak var newsArticleTitle: UILabel!
    @IBOutlet weak var newsArticleSelfText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: NewsArticle? {
        didSet {
            guard let _item = item else { return }
            updateUI(newsArticle: _item)
        }
    }
    
    func updateUI (newsArticle: NewsArticle) {
        if let url = URL(string: newsArticle.thumbnail), newsArticle.thumbnail != "default" {
            newsArticleImage.kf.setImage(with: url)
        }
        else {
            newsArticleImage.image = UIImage(named: "btn_RoundRect")
        }
        newsArticleImage.layer.cornerRadius = 6
        
        newsArticleTitle.text = newsArticle.title
        newsArticleSelfText.text = newsArticle.domain
        self.hideSkeleton()
    }
}

extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {

            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height

            var drawingRect: CGRect = self.bounds

            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
