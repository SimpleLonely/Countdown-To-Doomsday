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
        
        updateHistory(days: Int((result as! NSString).intValue))
        
        self.view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                loadFromSql()
                if let temp = dataManager.loadDataFromFile(pathToFile: HistoryData.ArchiveURL.path) {
                    historyData = temp as! [HistoryData]
                }
                if historyData.count == 0{
                    historyData.append(HistoryData(date: time.getCurrentTime(currentDate: Date()), amount: String(day), mail: defaults.string(forKey: "currentMail") ?? "default@mail"))
                }
            }
        }
        
        //只会在最后一天进行修改
        historyData[historyData.count-1].amount = String(Int(historyData[historyData.count-1].amount) ?? 0 + day)
        
        let queryService = QueryService()
        queryService.httpRequest(request:queryService.addHistoryItemRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: historyData[historyData.count-1].date, amount: historyData[historyData.count-1].amount)){
            (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                print("history update",data)
            }
            
        }
        print (historyData)
        dataManager.saveDataToFile(dataList: historyData, pathToFile: historyDict)
    }
    func loadFromSql(){
        let queryService = QueryService()
        let time = Time()
        queryService.httpRequest(request: queryService.getHistoryRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail"))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                let dataAfter = data.data(using: String.Encoding.utf8)
                let jsonDic = try! JSONSerialization.jsonObject(with: dataAfter!,                                         options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                var dataValue = NSArray()
                if let temp = jsonDic.value(forKey: "data") as? NSArray{
                    dataValue = temp
                    var tempData:[HistoryData] = []
                    for item in dataValue{
                        let item = item as! NSDictionary
                        tempData.append(HistoryData(date: time.getCurrentTime(currentDate: Date()), amount: item.value(forKey: "amount") as! String, mail: self.defaults.string(forKey: "currentMail") ?? "default@mail"))
                        
                    }
                    print("Save TO FILE")
                    let dataManager = DataManager(filePath:HistoryData.ArchiveURL.path)
                    dataManager.saveDataToFile(dataList: tempData, pathToFile: HistoryData.ArchiveURL.path)
                }
            }
        }
        
    }
    
}

