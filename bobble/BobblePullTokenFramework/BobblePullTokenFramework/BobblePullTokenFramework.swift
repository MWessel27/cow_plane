//
//  BobblePullTokenFramework.swift
//  BobblePullTokenFramework
//
//  Created by Mikalangelo Wessel on 8/23/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import Foundation
import UIKit
import os.log

public class BobblePullTokens: NSObject, NSCoding {
    public var bobblePullTokenCount: Int
    
    struct PropertyKey {
        static let bobblePullTokenCount = "bobblePullTokenCount"
    }
    
    public init?(bobblePullTokenCount: Int) {
        
        self.bobblePullTokenCount = bobblePullTokenCount
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(bobblePullTokenCount, forKey: PropertyKey.bobblePullTokenCount)
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let bobblePullTokenCount = aDecoder.decodeInteger(forKey: PropertyKey.bobblePullTokenCount) as? Int else {
            os_log("Unable to decode the bobblePullTokenCount for user.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(bobblePullTokenCount: bobblePullTokenCount)
    }
}


