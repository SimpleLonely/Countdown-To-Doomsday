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
    
    var dict:NSMutableDictionary!
    
    var notesArray:NSMutableArray!
    
    var plistPath:String!
    
    let M_e = 2.71828182845904523536028747135266250
    
    var Q:Double = 0.0
    
    var n:Double = 0
    
    
    var t12:Double = 0
    
    var tou:Double = 0.0
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.initialDocPath
        
        dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        let tempString = dict!.object(forKey: "Equipments") as! [String]

        
        currentT.text = String(dT(2018.0))
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func P(Q _Q:Double,n _n:Double,t12 _t12:Double,tou _tou:Double,t _t:Double) -> Double {
        let up = _Q*(pow(2.0, _n)-1) * pow(M_e, (_t-_t12)/_tou)
        let down = _n*_tou*pow(1+(pow(2.0, _n)-1)*pow(M_e, (_t-_t12)/_tou), (_n+1)/_n)
        return up/down
    }

    func E(_ _t:Double) -> Double {
        let P_coal = P(Q: 1.5*pow(10.0,12.0), n: 1.05,  t12: 2061, tou: 43.43, t: _t)
        print ("coal"+String(P_coal))
        let P_oil = P(Q: 2*pow(10.0, 12.0), n: 2.826, t12: 2005, tou: 13.37, t: _t)
        print ("oil"+String(P_oil))
        let P_gas = P(Q: 15*pow(10.0, 15.0), n: 7.125, t12: 2056, tou: 13.97, t: _t)
        print ("gas"+String(P_gas))
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
        
        let c = 0.47*(ETotal(tn,1700)-delt)
        
        return c
    }
    
    func reduceCarbon() -> Double {
        return 0
    }
    
    func dT(_ tn:Double) -> Double{
        let k = 3.0/log(2)
        let C1700 = C(1700,0)
        print("C1700:"+String(C1700))
        let Cnow = C(tn, reduceCarbon())
        print("Cnow:"+String(Cnow))
        return k*(log(Cnow/280))
    }
}

