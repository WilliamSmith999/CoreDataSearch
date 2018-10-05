//
//  Document.swift
//  Documents
//
//  Created by Dale Musser on 6/7/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import Foundation

struct Document {
    let url: URL
    let name: String
    let size: UInt64
    let modificationDate: Date

    var content: String? {
        get {
            return try? String(contentsOf: url, encoding: .utf8)
        }
    }
}
