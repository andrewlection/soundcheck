//
//  Song.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Song: Codable {
    let name: String
    let tape: Bool?
    let info: String?
    let cover: Cover?
    
    var isCover: Bool {
        return cover != nil
    }
    
    var isTape: Bool {
        return tape ?? false
    }
}
