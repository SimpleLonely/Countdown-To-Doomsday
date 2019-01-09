//
//  MonthlyThingsData.swift
//  Countdown
//
//  Created by mac on 1/7/19.
//  Copyright © 2019 nju. All rights reserved.
//

import UIKit
import os.log

struct PropertyKeyForMonthlyThing {
    static let thing = "thing"
    static let amount = "amount"
    static let tip = "tip"
}

class MonthlyThing:NSObject,NSCoding{
    //MARK: the monthly things contains thingName,amount and tip
    var thing:String
    var amount:String
    var tip:String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("monthlyThingsData")
    
    init(thing:String,amount:String,tip:String) {
        self.thing = thing
        self.amount = amount
        self.tip = tip
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(thing, forKey: PropertyKeyForMonthlyThing.thing)
        aCoder.encode(amount, forKey: PropertyKeyForMonthlyThing.amount)
        aCoder.encode(tip,forKey: PropertyKeyForMonthlyThing.tip)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let thing = aDecoder.decodeObject(forKey: PropertyKeyForMonthlyThing.thing) as? String else {
            os_log("Unable to decode the name for a MonthlyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let amount = aDecoder.decodeObject(forKey: PropertyKeyForMonthlyThing.amount) as? String else {
            os_log("Unable to decode the amount for a MonthlyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let tip = aDecoder.decodeObject(forKey: PropertyKeyForMonthlyThing.tip) as? String else{
            os_log("Unable to decode the mail for a MonthlyThing object.", log:OSLog.default,type:.debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(thing:thing,amount:amount,tip:tip)
    }
}

