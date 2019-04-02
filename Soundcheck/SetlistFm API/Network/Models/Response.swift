//
//  Response.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 11/4/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public struct Response<T: Decodable>: Decodable {

    public let type: String
    public let itemsPerPage: Int
    public let page: Int
    public let total: Int
    public let model: [T]?
    
    struct ResponseCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
        
        static func createKey(name: String) -> ResponseCodingKey {
            return ResponseCodingKey(stringValue: name)!
        }
    }
    
    public init(from decoder: Decoder) throws {
        // Select key for type of response
        let modelKey: String
        
        switch T.self {
            case is Artist.Type:
                modelKey = "artist"
            case is Setlist.Type:
                modelKey = "setlist"
            default:
                modelKey = ""
        }
        
        // Decode
        let container = try decoder.container(keyedBy: ResponseCodingKey.self)
        let type = try container.decode(String.self, forKey: ResponseCodingKey.createKey(name: "type"))
        let itemsPerPage = try container.decode(Int.self, forKey: ResponseCodingKey.createKey(name: "itemsPerPage"))
        let page = try container.decode(Int.self, forKey: ResponseCodingKey.createKey(name: "page"))
        let total = try container.decode(Int.self, forKey: ResponseCodingKey.createKey(name: "total"))
        let model = try container.decode([T].self, forKey: ResponseCodingKey.createKey(name: modelKey))
        
        // Initialize
        self.type = type
        self.itemsPerPage = itemsPerPage
        self.page = page
        self.total = total
        self.model = model
    }
}
