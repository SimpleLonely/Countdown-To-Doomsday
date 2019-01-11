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
    
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        
        let figure = Figure()
        
        let result = figure.countDown()
        
        countDown.text = result+"天"
        
        if QueryService.isAppAlreadyLaunchedOnce(){
            defaults.set(false, forKey: "loginStatus")
        }
        
        self.view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
       
        let figure = Figure()
        
        let result = figure.countDown()
        
        countDown.text = result+"天"
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

