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
        
        UserDefaults.standard.set(true, forKey: "loginStatus")
        
        UserDefaults.standard.set("MyName", forKey: "Name")
        
        UserDefaults.standard.set("My Introduction", forKey: "Introduction")
        
        let figure = Figure()
        
        countDown.text = figure.countDown()+"天"
        
        self.view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func updateHistory(days day:Int){
        var data:[HistoryData]!
        let historyDict = HistoryData.ArchiveURL.path
        print("historyDict"+historyDict)
        let dataManager = DataManager(filePath: historyDict)
        let historyData = dataManager.loadDataFromFile(pathToFile:historyDict)
        data = (historyData as! [HistoryData])
        
        //只会在最后一天进行修改
        data[data.count-1].amount = String(Int(data[data.count-1].amount) ?? 0 + day)
        
        //TODO: async to sql and async to change UI
        
        let queryService = QueryService()
        
   queryService.httpRequest(request:queryService.addHistoryItemRequest(mail: defaults.object(forKey: "currentMail") as! String, date: data[data.count-1].date, amount: data[data.count-1].amount)){
            (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                for item in data{
                    
                    //monthlyData[item.date] = item.amount
                }
                print(data)
                
            }
            
        }
        
        
        dataManager.saveDataToFile(dataList: data, pathToFile: historyDict)
        
        
    }
    
}

