//
//  PlaylistSong.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

final class PlaylistSong {
    let artistName: String 
    let name: String
    var audioUrl: String?
    
    init(artistName: String, name: String) {
        self.artistName = artistName
        self.name = name
    }
}
