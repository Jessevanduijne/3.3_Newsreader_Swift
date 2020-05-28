//
//  User.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 23-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation

struct Login: Codable {
    let AuthToken: String
    
    enum CodingKeys: String, CodingKey {
        case AuthToken = "AuthToken"
    }
}
