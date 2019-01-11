//
//  DataManager.swift
//  Countdown
//
//  Created by mac on 12/31/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import os.log

class DataManager{
    var dataList:[NSObject]?
    var filePath:String
    
    init(filePath:String) {
        self.filePath = filePath
    }
    
    public func saveDataToFile(dataList data:[NSObject],pathToFile path:String){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: path)
        if isSuccessfulSave {
        os_log("Data successfully saved.", log: OSLog.default, type: .debug)
        } else {
        os_log("Failed to save datas...", log: OSLog.default, type: .error)
        }
    }
    
    public func loadDataFromFile(pathToFile path:String) -> [NSObject]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [NSObject]
    }
    public func loadDataFromFile(pathToFile path:String,onlyToday flag:Bool,isMonthly:Bool) -> [NSObject]?{
        let time = Time()
        if (isMonthly){
            let pre = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            var toReturn:[MonthlyThing] = []
            if let temp = pre {
                let monthlyData = temp as! [MonthlyThing]
                for item in monthlyData{
                    if item.date == time.getCurrentTime(currentDate: Date()){
                        toReturn.append(item)
                    }
                }
            }
            return toReturn
        }else{
            let pre = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            var toReturn:[DailyThing] = []
            if let temp = pre{
                let dailyData = temp as! [DailyThing]
                for item in dailyData{
                    if item.date == time.getCurrentTime(currentDate: Date()){
                        toReturn.append(item)
                    }
                }
            }
            
            return toReturn
        }
        
    }
}
