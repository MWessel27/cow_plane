//
//  bobble.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import os.log

class Bobble: NSObject, NSCoding {
    var image: String
    var name: String
    var number: Int
    var outOf: Int
    var bobbleDescription: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bobbles")
    
    struct PropertyKey {
        static let image = "image"
        static let name = "name"
        static let number = "number"
        static let outOf = "outOf"
        static let bobbleDescription = "bobbleDescription"
    }
    
    init?(image: String, name: String, number: Int, outOf: Int, bobbleDescription: String) {
        guard !image.isEmpty else {
            return nil
        }
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard !bobbleDescription.isEmpty else {
            return nil
        }
        
        if(number == 0 || number > outOf || outOf == 0) {
            return nil
        }
        
        self.image = image
        self.name = name
        self.number = number
        self.outOf = outOf
        self.bobbleDescription = bobbleDescription
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(number, forKey: PropertyKey.number)
        aCoder.encode(outOf, forKey: PropertyKey.outOf)
        aCoder.encode(bobbleDescription, forKey: PropertyKey.bobbleDescription)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? String else {
            os_log("Unable to decode the image for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let number = aDecoder.decodeInteger(forKey: PropertyKey.number) as? Int else {
            os_log("Unable to decode the number for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let outOf = aDecoder.decodeInteger(forKey: PropertyKey.outOf) as? Int else {
            os_log("Unable to decode the image for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let bobbleDescription = aDecoder.decodeObject(forKey: PropertyKey.bobbleDescription) as? String else {
            os_log("Unable to decode the bobbleDescription for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(image: image, name: name, number: number, outOf: outOf, bobbleDescription: bobbleDescription)
    }
}
