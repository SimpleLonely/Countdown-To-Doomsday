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
    static let mail = "mail"
    static let date = "date"
}

class MonthlyThing:NSObject,NSCoding{
    //MARK: the monthly things contains thingName,amount and mail
    var thing:String
    var amount:String
    var mail:String
    var date:String
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("monthlyThingsData")
    
    init(thing:String,amount:String,mail:String,date:String) {
        self.thing = thing
        self.amount = amount
        self.mail = mail
        self.date = date
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(thing, forKey: PropertyKeyForMonthlyThing.thing)
        aCoder.encode(amount, forKey: PropertyKeyForMonthlyThing.amount)
        aCoder.encode(mail,forKey: PropertyKeyForMonthlyThing.mail)
        aCoder.encode(date,forKey:PropertyKeyForMonthlyThing.date)
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
        
        guard let mail = aDecoder.decodeObject(forKey: PropertyKeyForMonthlyThing.mail) as? String else{
            os_log("Unable to decode the mail for a MonthlyThing object.", log:OSLog.default,type:.debug)
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: PropertyKeyForMonthlyThing.date) as? String else{
            os_log("Unable to decode the date for a MonthlyThing object.", log:OSLog.default,type:.debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(thing:thing,amount:amount,mail:mail,date: date)
    }
}

