//
//  Time.swift
//  Countdown
//
//  Created by mac on 1/10/19.
//  Copyright © 2019 nju. All rights reserved.
//

import Foundation

class Time {
    let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "YY-MM-dd"
    }
    func getCurrentTime(currentDate:Date) -> String{
        return dateFormatter.string(from:currentDate)
    }
}
