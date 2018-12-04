//
//  ViewController.swift
//  Countdown
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 nju. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var currentT: UILabel!
    @IBOutlet weak var countDown: UILabel!
    
    var initialDataPlistPath:String!
    
    var monthlyPlistPath:String!
    
    var dailyPlistPath:String!
    
    var initialData:NSMutableDictionary!
    
    var monthlyData:NSMutableDictionary!
    
    var dailyData:NSMutableDictionary!
    
    let M_e = 2.71828182845904523536028747135266250

    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        initialDataPlistPath = appDelegate.initialDocPath
        
        
        monthlyPlistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        dailyPlistPath = appDelegate.dailyThingsPlistPathInDocument
        
        initialData = NSMutableDictionary(contentsOfFile: initialDataPlistPath!)
        
        monthlyData = NSMutableDictionary(contentsOfFile: monthlyPlistPath!)
        
        dailyData = NSMutableDictionary(contentsOfFile: dailyPlistPath!)
        
        countDown.text = String(Int((1.5/(0.65-(0.35-dT(2018.0)))*10)*365))+"天"
        
        self.view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        initialDataPlistPath = appDelegate.initialDocPath
        
        monthlyPlistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        dailyPlistPath = appDelegate.dailyThingsPlistPathInDocument
        
        initialData = NSMutableDictionary(contentsOfFile: initialDataPlistPath!)
        
        monthlyData = NSMutableDictionary(contentsOfFile: monthlyPlistPath!)
        
        dailyData = NSMutableDictionary(contentsOfFile: dailyPlistPath!)
        
        currentT.text = "+0.35摄氏度"
        
        let currentCountDown = Int((1.5/(0.65-(-0.35-dT(2018.0))))*3650)
        
        countDown.text = String(currentCountDown)+"天"
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
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
        print("pTotal:"+String(p_total))
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
        
        let initialString = initialData.object(forKey: "Data") as! [String]
        let monthlyString = monthlyData.object(forKey: "Amount") as! [Float]
        
        let carBefore = (initialString[7] as NSString).floatValue
        let carAfter = monthlyString[2]
        let oilPerMile = (initialString[4] as NSString).floatValue
        let carReduce = (carBefore-carAfter)*oilPerMile*(2.7-0.036) * 0.7
        
        let elecBefore = (initialString[6] as NSString).floatValue
        let elecAfter = monthlyString[1]
        let elecReduce = (elecBefore-elecAfter)*0.785*0.7
        
        let waterBefore = (initialString[5] as NSString).floatValue
        let waterAfter = monthlyString[0]
        let waterReduce = (waterBefore-waterAfter)*0.91*0.7
        
        return Double(carReduce+elecReduce+waterReduce)
       
    }
    
    func dT(_ tn:Double) -> Double{
        let k = 3.0/log(2)
        let Cnow = C(tn, reduceCarbon())*0.278
        print("Cnow:"+String(Cnow))
        return k*(log(Cnow/280))
    }
    
    func updateHistory(){
        
    }
    
}

