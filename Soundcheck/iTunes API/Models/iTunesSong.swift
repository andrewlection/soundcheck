//
//  iTunesSong.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

public struct iTunesSong: Decodable {
    let artistName: String?
    let collectionName: String?
    let previewUrl: String?
    let trackName: String?
}
