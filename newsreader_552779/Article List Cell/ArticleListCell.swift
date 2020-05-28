//
//  ArticleListCell.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation
import UIKit

class ArticleListCell: UITableViewCell {
    
    @IBOutlet weak var articleListImage: UIImageView!
    @IBOutlet weak var articleListTitle: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var articleID: Int = 0   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleListTitle.text = ""
        articleListImage.image = nil
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        let request = ArticlesAPI.updateLike(articleId: articleID)
        
        request.responseData(completionHandler: {[weak self] (response) in
            self?.likeButton.setImage(UIImage(named: "likedstar"), for: .normal)
        })
    }
}
