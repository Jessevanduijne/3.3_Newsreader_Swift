//
//  Article.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation

struct Article: Codable {
    let Id, Feed: Int
    let Title, Summary, PublishDate: String
    let Image: String
    let Url: String
    let Related: [String]
    let Categories: [Category]
    let IsLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case Id = "Id"
        case Feed = "Feed"
        case Title = "Title"
        case Summary = "Summary"
        case PublishDate = "PublishDate"
        case Image = "Image"
        case Url = "Url"
        case Related = "Related"
        case Categories = "Categories"
        case IsLiked = "IsLiked"
    }
}
