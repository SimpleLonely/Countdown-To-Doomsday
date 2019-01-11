//
//  DailyThingsData.swift
//  Countdown
//
//  Created by mac on 1/7/19.
//  Copyright © 2019 nju. All rights reserved.
//

import UIKit
import os.log

struct PropertyKeyForDailyThing {
    static let question = "question"
    static let answer = "answer"
    static let mail = "mail"
    static let date = "date"
}

class DailyThing:NSObject,NSCoding{
    //MARK: the daily things contains question and answer
    var question:String
    var answer:String
    var mail:String
    var date:String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dailyThingsData")
    
    init(question:String,answer:String,mail:String,date:String) {
        self.question = question
        self.answer = answer
        self.mail = mail
        self.date = date
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(question,forKey:PropertyKeyForDailyThing.question)
        aCoder.encode(answer,forKey:PropertyKeyForDailyThing.answer)
        aCoder.encode(mail,forKey:PropertyKeyForDailyThing.mail)
        aCoder.encode(date,forKey:PropertyKeyForDailyThing.date)
        
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let question = aDecoder.decodeObject(forKey: PropertyKeyForDailyThing.question) as? String else {
            os_log("Unable to decode the name for a DailyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let answer = aDecoder.decodeObject(forKey: PropertyKeyForDailyThing.answer) as? String else {
            os_log("Unable to decode the answer for a DailyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let mail = aDecoder.decodeObject(forKey: PropertyKeyForDailyThing.mail) as? String else {
            os_log("Unable to decode the mail for a DailyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: PropertyKeyForDailyThing.date) as? String else {
            os_log("Unable to decode the date for a DailyThing object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(question:question,answer:answer,mail:mail,date:date)
    }
}

