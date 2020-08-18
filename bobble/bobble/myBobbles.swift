//
//  myBobbles.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/17/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import Foundation

import UIKit
import os.log

class myBobbles: NSObject, NSCoding {
    var id: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("myBobbles")
    
    struct PropertyKey {
        static let id = "id"
    }
    
    init?(id: Int) {
        
        if(id == 0) {
            return nil
        }
        
        self.id = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeInteger(forKey: PropertyKey.id) as? Int else {
            os_log("Unable to decode the id for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(id: id)
    }
}
