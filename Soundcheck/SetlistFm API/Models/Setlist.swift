//
//  Setlist.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/28/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Setlist: Codable {
    let id: String
    let versionId: String
    let eventDate: String
    let lastUpdated: String
    let artist: Artist
    let venue: Venue
    let tour: Tour?
    let sets: SetsContainer
    let info: String?
    let url: String?
}

