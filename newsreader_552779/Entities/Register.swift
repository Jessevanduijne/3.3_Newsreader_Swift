//
//  Register.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 23-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation

struct Register: Codable {
    let Success: Bool
    let Message: String
    
    enum CodingKeys: String, CodingKey {
        case Success = "Success"
        case Message = "Message"
    }
}

