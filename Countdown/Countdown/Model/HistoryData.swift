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
    var amount:String
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    private var dataTask: URLSessionDataTask?
    
    private var errorMessage=""
    let baseUrl = "http://47.106.153.201/"
    
    let defaultMail = "default@mail"
    
    let userDefaults = UserDefaults.standard
    typealias JSONDictionary = [String: Any]
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("historyData")

    init(date:String,amount:String) {
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
        guard let amount = aDecoder.decodeObject(forKey: PropertyKey.amount) as? String else {
            os_log("Unable to decode the amount for a History object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(date:date,amount:amount)
    }
}
