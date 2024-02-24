//
//  NSCache+Subscript.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ url: URL) -> CacheEntry? { // subscripts allows read/write to cache with a dictionary-like notation
        // key-value relation between url-entry
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key) // remove value when assigned to nil, mimics dict. behaviour
            }
        }
    }
}
