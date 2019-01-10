//
//  FigureCountDown.swift
//  Countdown
//
//  Created by mac on 1/10/19.
//  Copyright © 2019 nju. All rights reserved.
//

import UIKit

class Figure {
    let defaults = UserDefaults.standard

    var initialDocSize = 0
    
    var monthlyDocSize = 0
    
    var dailyDocSize = 0
    
    var currentCountDown = 0
    
    var lastCountDown = 0
    
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
        print ("total:"+String(total))
        return total
    }
    func C(_ tn:Double,_ delt:Double) -> Double{
        
        let c = 0.47*(E(tn)-delt)
        
        return c
    }
    func reduceCarbon() -> Double {
        
        if (initialDocSize>0 && monthlyDocSize>0){
            let carBefore = (initialString[7] as NSString).floatValue
            let carAfter = (monthlyString[2] as NSString).floatValue
            let oilPerHundMile = (initialString[4] as NSString).floatValue
            let carReduce = (carBefore-carAfter)*oilPerHundMile/100*(2.7-0.036) * 0.07
            
            let elecBefore = (initialString[6] as NSString).floatValue
            let elecAfter = (monthlyString[1] as NSString).floatValue
            let elecReduce = (elecBefore-elecAfter)*0.785*0.07
            
            let waterBefore = (initialString[5] as NSString).floatValue
            let waterAfter = (monthlyString[0] as NSString).floatValue
            let waterReduce = (waterBefore-waterAfter)*0.91*0.07
            
            return Double(carReduce+elecReduce+waterReduce)
        }
        else{
            return 0.0
        }
    }
    
    func dT(_ tn:Double) -> Double{
        let k = 3.0/log(2)
        var Cnow = C(tn, reduceCarbon())*0.278
        //print("Cnow:"+String(Cnow))
        if Cnow<=0 {
            Cnow = 360
        }
        return k*(log(Cnow/280))
    }
    func countDown() -> String{
        let f = (1.5/(0.65-(-0.35-dT(2018.0))))*36500
        
        currentCountDown = 1
        do{
            currentCountDown = Int(f)
        };
        let history = Int(currentCountDown) - lastCountDown
        /*
        print ("history1:"+String(history))
        if history < 5000{
            updateHistory(days:history)
        }*/
        lastCountDown = currentCountDown
        return String(currentCountDown);
        
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
        
        //MARK: handle initial docs
        for i in 0...initialDocSize-1{
            if let temp = defaults.string(forKey: "initialDoc-"+String(i)){
                initialString.append(temp)
            }
        }
        if initialString.count == 0{
            initialDocSize = 0
        }
        
        //MARK: handle monthly things datas
        let dataManager = DataManager(filePath: MonthlyThing.ArchiveURL.path)
        
        var monthlyData:[MonthlyThing] = []
        
        if let preData = dataManager.loadDataFromFile(pathToFile: MonthlyThing.ArchiveURL.path){
            monthlyData = preData as! [MonthlyThing]
            for item in monthlyData{
                monthlyString.append(item.amount)
            }
        }else{
            monthlyDocSize = 0;
        }
        
        
    }
}
