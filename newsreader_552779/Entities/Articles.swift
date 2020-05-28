//
//  Articles.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation

struct Articles: Codable {
    let Results: [Article]
    let NextID: Int
    
    enum CodingKeys: String, CodingKey {
        case Results = "Results"
        case NextID = "NextId"
    }
}
