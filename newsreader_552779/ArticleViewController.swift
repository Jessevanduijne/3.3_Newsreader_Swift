//
//  ArticleViewController.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 19-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

class ArticleViewController : UIViewController {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleCategories: UILabel!
    @IBOutlet weak var articleLink: UIButton!
    
    var article: Article? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageUrl = URL(string: (article?.Image)!)
        
        articleImage.kf.setImage(with: imageUrl)
        articleText.text = article?.Summary
        articleTitle.text = article?.Title
        articleDate.text = article?.PublishDate
        
        articleCategories.text? = ""
        for category in (article?.Categories)! {
            articleCategories.text?.append(" " + category.Name)
        }
    }
    
    @IBAction func readMoreButton(_ sender: Any) {
        //UIApplication.shared.openURL(URL(linkUrl)!)
      //  if let linkUrl = NSURL(string: linkUrl) {
//      UIApplication.shared.open(linkUrl as URL)
     //   }
        guard let url = URL(string: (article?.Url)!) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
