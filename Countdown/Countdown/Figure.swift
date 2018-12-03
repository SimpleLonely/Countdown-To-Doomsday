//
//  Figure.swift
//  Countdown
//
//  Created by mac on 12/3/18.
//  Copyright © 2018 nju. All rights reserved.
//

import Foundation
class figure {
    
    
    
    func P(Q _Q:Double,n _n:Double,x _x:Double,t12 _t12:Double,tou _tou:Double,t _t:Double) -> Double {
        let up = _Q*(pow(2.0, _x)-1) * pow(M_e, (_t-_t12)/_tou)
        let down = _n*_tou*pow(1+(pow(2.0, _n)-1)*pow(M_e, (_t-_t12)/_tou), n/(n+1))
        return up/down
    }
    
    
}
