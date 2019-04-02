//
//  SetlistFMClient+Query.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 11/4/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

extension SetlistFM {

    // Returns artists for artist name query
    public func artistsFor(name: String, completion: @escaping (Result<[Artist]>) -> ()) {
        request("/search/artists", method: .GET, params: ["artistName" : name], completion: completion)
    }
    
    // Returns setslits for a given MBID
    public func setlistsForArtist(mbid: String, completion: @escaping (Result<[Setlist]>) -> ()) {
        request("/artist/" + mbid + "/setlists", method: .GET, completion: completion)
    }
    
    // Returns setlists for artist name
    public func setlistsFor(artistName: String, completion: @escaping (Result<[Setlist]>) -> ()) {
        request("/search/setlists", method: .GET, params: ["artistName": artistName], completion: completion)
    }
}
