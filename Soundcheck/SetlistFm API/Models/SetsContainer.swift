//
//  SetsWrapper.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 11/4/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct SetsContainer: Codable {
    let sets: [Set]
    
    private enum CodingKeys: String, CodingKey {
        case sets = "set"
    }
}
