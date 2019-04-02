//
//  Result.swift
//  SwiftSetList
//
//  Created by Andrew Lection on 10/30/17.
//  Copyright © 2017 Andrew Lection. All rights reserved.
//

import Foundation

public enum Result<T> {
    case failure(Error)
    case success(T)
}
