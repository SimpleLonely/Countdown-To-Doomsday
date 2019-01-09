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
}

class DailyThing:NSObject,NSCoding{
    //MARK: the daily things contains question and answer
    var question:String
    var answer:String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dailyThingsData")
    
    init(question:String,answer:String) {
        self.question = question
        self.answer = answer
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(question,forKey:PropertyKeyForDailyThing.question)
        aCoder.encode(answer,forKey:PropertyKeyForDailyThing.answer)
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
        
        // Must call designated initializer.
        self.init(question:question,answer:answer)
    }
}

