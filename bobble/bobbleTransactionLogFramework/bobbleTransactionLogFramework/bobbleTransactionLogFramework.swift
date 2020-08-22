//
//  bobbleTransactionLogFramework.swift
//  bobbleTransactionLogFramework
//
//  Created by Mikalangelo Wessel on 8/22/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import Foundation
import UIKit
import os.log

public class bobbleTransactionLog: NSObject, NSCoding {
    public var transactionId: Int
    
    struct PropertyKey {
        static let transactionId = "transactionId"
    }
    
    public init?(transactionId: Int) {
        
        if(transactionId == 0) {
            return nil
        }
        
        self.transactionId = transactionId
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(transactionId, forKey: PropertyKey.transactionId)
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let transactionId = aDecoder.decodeInteger(forKey: PropertyKey.transactionId) as? Int else {
            os_log("Unable to decode the transaction log for a Bobble object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(transactionId: transactionId)
    }
}

