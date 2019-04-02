//
//  City.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct City: Codable {
    let id: String
    let name: String
    let state: String?
    let stateCode: String?
    let coords: Coords
    let country: Country
}

