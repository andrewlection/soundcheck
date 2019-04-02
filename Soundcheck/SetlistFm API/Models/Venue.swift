//
//  Venue.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Venue: Codable {
    let id: String
    let name: String
    let city: City
    let url: String?
}

