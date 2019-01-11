//
//  FigureCountDown.swift
//  Countdown
//
//  Created by mac on 1/10/19.
//  Copyright © 2019 nju. All rights reserved.
//

import UIKit

//http://www.roperld.com/science/globalwarmingmathematics.htm
//use equation of this page
//to figure a rough result
class Figure {
    let defaults = UserDefaults.standard

    var initialDocSize = 0
    
    var monthlyDocSize = 0
    
    var dailyDocSize = 0
    
    static var currentCountDown = 0
    
    static var lastCountDown = 0
    
    static var carReduce = 0.0
    
    var initialString:[String] = []
    
    var monthlyString:[String] = []
    
    
    let M_e = 2.71828182845904523536028747135266250
    
    func P(Q _Q:Double,n _n:Double,t12 _t12:Double,tou _tou:Double,t _t:Double) -> Double {
        let up = _Q*(pow(2.0, _n)-1) * pow(M_e, (_t-_t12)/_tou)
        let down = _n*_tou*pow(1+(pow(2.0, _n)-1)*pow(M_e, (_t-_t12)/_tou), (_n+1)/_n)
        return up/down
    }
    func E(_ _t:Double) -> Double {
        let P_coal = P(Q: 1.5*pow(10.0,12.0), n: 1.05,  t12: 2061, tou: 43.43, t: _t)/1000000
        //print ("coal"+String(P_coal))
        let P_oil = P(Q: 2*pow(10.0, 12.0), n: 2.826, t12: 2005, tou: 13.37, t: _t)/1000000000
        //print ("oil"+String(P_oil))
        let P_gas = P(Q: 15*pow(10.0, 15.0), n: 7.125, t12: 2056, tou: 13.97, t: _t)/1000000000000
        //print ("gas"+String(P_gas))
        let p_total = P_coal*0.907*0.5*0.75 + P_oil*0.136*0.84*0.75 + P_gas*0.0189*0.76*0.75
        //print("pTotal:"+String(p_total))
        return p_total
    }
    func ETotal(_ tn:Double,_ start:Double) -> Double {
        var total:Double = 0.0
        for i in Int(start)...Int(tn){
            let ti = Double(i)
            total += E(ti)*(0.0875*pow(M_e,(tn-ti)/35600)+0.165*pow(M_e, (tn-ti)/682)+0.733*pow(M_e, (tn-ti)/50.8))
            //print ("totali:"+String(i)+"  "+String(total))
        }
        return total
    }
    func C(_ tn:Double,_ delt:Double) -> Double{
        
        let c = 0.47*(E(tn)-delt)
        
        return c
    }
    
    func dT(_ tn:Double) -> Double{
        let k = 3.0/log(2)
        
        var Cnow = C(tn, Figure.carReduce)*0.278
        //每次回到主页面就会重置
        Figure.carReduce = 0
        
        if Cnow<=0 {
            Cnow = 360
        }
        return k*(log(Cnow/280))
    }
    
    func countDown() -> String{
        let f = (1.5/(0.65-(-0.35-dT(2018.0))))*36500
        
        do{
            Figure.currentCountDown = Int(f)
        };
        let history = Int(Figure.currentCountDown) - Figure.lastCountDown
        
        print ("history1:",history)
        if history < 5000 && history > 0{
            updateHistory(days:history)
        }
        Figure.lastCountDown = Figure.currentCountDown
        return String(Figure.currentCountDown);
    }
    
    func updateHistory(days day:Int){
        var historyData:[HistoryData]=[]
        let historyDict = HistoryData.ArchiveURL.path
        let dataManager = DataManager(filePath: historyDict)
        
        let time = Time()
        if let temp = dataManager.loadDataFromFile(pathToFile: HistoryData.ArchiveURL.path) {
            historyData = temp as! [HistoryData]
        }else{
                if historyData.count == 0{
                    historyData.append(HistoryData(date: time.getCurrentTime(currentDate: Date()), amount: String(day), mail: defaults.string(forKey: "currentMail") ?? "default@mail"))
                }
        }
        
        //只会在最后一天进行修改
        let currentData = Int(historyData[historyData.count-1].amount) ?? 0
        historyData[historyData.count-1].amount = String( currentData + day)
        dataManager.saveDataToFile(dataList: historyData, pathToFile: historyDict)
    }

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var plistPath = appDelegate.initialDocPath
        
        var dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        let initial = dict?.object(forKey: "Equipments") as! [String]
        
        initialDocSize = initial.count
        
        plistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        let monthly = dict?.object(forKey: "Thing") as! [String]
        
        monthlyDocSize = monthly.count
        
    }
    
}
