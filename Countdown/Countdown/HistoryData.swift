//
//  HistoryData.swift
//  Countdown
//
//  Created by mac on 12/31/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import os.log
struct PropertyKey {
    static let date = "date"
    static let amount = "amount"
}


class HistoryData: NSObject, NSCoding{
    var date:String
    var amount:Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("historyData")

    init(date:String,amount:Int) {
        self.date = date
        self.amount = amount
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(amount, forKey: PropertyKey.amount)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else {
            os_log("Unable to decode the name for a History object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let amount = aDecoder.decodeObject(forKey: PropertyKey.amount) as? Int
        
        
        // Must call designated initializer.
        self.init(date:date,amount:amount!)
    }
    
    
    
}
