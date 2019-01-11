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
        
        getCurrentTemperature()
        
        if QueryService.isAppAlreadyLaunchedOnce(){
            defaults.set(false, forKey: "loginStatus")
        }
        
        self.view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
       
        let figure = Figure()
        
        let result = figure.countDown()
        if (QueryService.isAppAlreadyLaunchedOnce()){
            alert()
        }
        countDown.text = result+"天"
        
        super.viewDidLoad()
        
    }
    //Mark:第一次打开的提示
    func alert (){
       
        let alertController = UIAlertController(title: "Tip", message: " 请到设置页，填写您的初始档案", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction (title: "Confirm", style: .default,handler:nil)
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController,animated: true,completion: nil)
        
    }
    func  getCurrentTemperature()  {
        let queryService = QueryService()
        queryService.httpRequest(request: queryService.getTemperature())
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                let dataAfter = data.data(using: String.Encoding.utf8)
                let jsonDic = try! JSONSerialization.jsonObject(with: dataAfter!,                                         options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let dataValue = jsonDic.value(forKey: "data") as! Double
                let toDisplay = String(format: "%.2f", dataValue*0.1)
                DispatchQueue.main.async {
                    self.currentT.text = "+"+String(toDisplay)+"摄氏度"
                }
            }
        }
    }
    
}

