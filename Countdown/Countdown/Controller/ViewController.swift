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
    
    
    @IBOutlet weak var circle: UIImageView!
    let defaults = UserDefaults.standard
    
    func rotate1(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        rotate1(imageView: circle, aCircleTime: 10)
        
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

