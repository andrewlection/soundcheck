//
//  iTunesResponse.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

struct iTunesResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: [T]?
}
