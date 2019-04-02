//
//  Cover.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Cover: Codable {
    let mbid: String
    let name: String
    let sortName: String?
    let disambiguation: String?
    let url: String?
}
