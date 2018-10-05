//
//  DocumentManager.swift
//  Documents
//
//  Created by Dale Musser on 6/7/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import Foundation

class Documents {
    
    class func get() -> [Document] {
        var documents = [Document]()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let urls = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            for url in urls {
                let name = url.lastPathComponent
                if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
                    let size = attributes[FileAttributeKey.size] as? UInt64,
                    let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date {
                    documents.append(Document(url: url, name: name, size: size, modificationDate: modificationDate))
                }
            }
        }
        
        return documents
    }
    
    class func delete(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
    class func save(name: String, content: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent(name)

        try? content.write(to: url, atomically: true, encoding: .utf8)
    }
}
