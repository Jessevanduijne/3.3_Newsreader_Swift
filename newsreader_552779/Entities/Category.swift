//
//  Category.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation

struct Category: Codable {
    let Id: Int
    let Name: String
    
    enum CodingKeys: String, CodingKey {
        case Id = "Id"
        case Name = "Name"
    }
}
