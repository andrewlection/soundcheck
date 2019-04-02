//
//  Artist.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Artist: Codable {
    let mbid: String
    let tmid: Int?
    let name: String
    let disambiguation: String?
    let sortName: String?
    let url: String
}
