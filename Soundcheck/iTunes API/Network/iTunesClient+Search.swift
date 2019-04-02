//
//  iTunesClient+Search.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

extension iTunesClient {
    // Returns songs for search text
    public func searchMusicFor(_ searchText: String, completion: @escaping (Result<[iTunesSong]>) -> ()) {
        request("/search", method: .GET, params: ["media": iTunesClientMediaType.music.rawValue, "term": searchText], completion: completion)
    }
}
