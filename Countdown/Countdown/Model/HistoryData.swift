//
//  HistoryData.swift
//  Countdown
//
//  Created by mac on 12/31/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import os.log
struct PropertyKeyForHistory {
    static let date = "date"
    static let amount = "amount"
    static let mail = "mail"
}


class HistoryData: NSObject, NSCoding{
    //MARK: the history data contains date,amount and mail. Mail is getted from the userDefaults
    var date:String
    var amount:String
    var mail:String
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    private var dataTask: URLSessionDataTask?
    
    
    let defaultMail = "default@mail"
    
    let userDefaults = UserDefaults.standard
    typealias JSONDictionary = [String: Any]
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("historyData")

    init(date:String,amount:String,mail:String) {
        self.date = date
        self.amount = amount
        self.mail = mail
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKeyForHistory.date)
        aCoder.encode(amount, forKey: PropertyKeyForHistory.amount)
        aCoder.encode(mail,forKey: PropertyKeyForHistory.mail)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKeyForHistory.date) as? String else {
            os_log("Unable to decode the name for a History object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let amount = aDecoder.decodeObject(forKey: PropertyKeyForHistory.amount) as? String else {
            os_log("Unable to decode the amount for a History object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let mail = aDecoder.decodeObject(forKey: PropertyKeyForHistory.mail) as? String else{
            os_log("Unable to decode the mail for a History object.", log:OSLog.default,type:.debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(date:date,amount:amount,mail:mail)
    }
}
