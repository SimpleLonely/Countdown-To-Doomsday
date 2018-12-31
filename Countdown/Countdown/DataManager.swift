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
    
    public func saveData(dataList data:[NSObject],pathToFile path:String){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: path)
        if isSuccessfulSave {
        os_log("Data successfully saved.", log: OSLog.default, type: .debug)
        } else {
        os_log("Failed to save datas...", log: OSLog.default, type: .error)
        }
    }
    
    public func loadData(pathToFile path:String) -> [NSObject]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [NSObject]
    }
}
