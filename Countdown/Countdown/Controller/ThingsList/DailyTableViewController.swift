//
//  DailyTableViewController.swift
//  Countdown
//
//  Created by mac on 11/30/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit

class DailyTableViewController: UITableViewController {

    var questions:[String] = []
    
    var answers:[String] = []
    
    var dict:NSMutableDictionary!
    
    var plistPath:String!
    
    var dailyData:[DailyThing] = []
    
    let defaults = UserDefaults.standard
    
    let dataManger = DataManager(filePath: DailyThing.ArchiveURL.path)
    
    fileprivate func initData() {
        let dataManager = DataManager(filePath: DailyThing.ArchiveURL.path)
        if let preData = dataManager.loadDataFromFile(pathToFile: DailyThing.ArchiveURL.path) as? [DailyThing]{
            dailyData = preData
        }else{
            loadDataFromSql()
            if (dailyData.count == 0){
                let time = Time()
                for i in 0...questions.count-1{
                    dailyData.append(DailyThing(question: questions[i], answer:"N",mail:defaults.string(forKey: "currentMail") ?? "default@mail",date: time.getCurrentTime(currentDate: Date())))
                    answers.append("N")
                }
            }
            dataManager.saveDataToFile(dataList: dailyData, pathToFile: DailyThing.ArchiveURL.path)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.dailyThingsPlistPathInDocument
        
        dict = NSMutableDictionary(contentsOfFile: plistPath!)
        
        questions = dict!.object(forKey: "questions") as! [String]

        initData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }
    
    func uploadToSql(question:Int,answer:String){
        let queryService = QueryService()
        
        let time = Time()
        queryService.httpRequest(request: queryService.updateDailyDataRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: defaults.string(forKey: "currentDate") ?? time.getCurrentTime(currentDate: Date()),question: question, answer: answer))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                print("upload single Daily :",data)
            }
        }
    }

    func loadDataFromSql(){
        let queryService = QueryService()
        let time = Time()
        queryService.httpRequest(request: queryService.getAllDailyDataRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: defaults.string(forKey: "currentDate") ?? time.getCurrentTime(currentDate: Date())))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                let dataAfter = data.data(using: String.Encoding.utf8)
                let jsonDic = try! JSONSerialization.jsonObject(with: dataAfter!,                                         options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let dataValue = jsonDic.value(forKey: "data") as! NSArray
                for item in dataValue{
                    let item = item as! NSDictionary
                    self.dailyData[item.value(forKey: "question") as! Int].answer = item.value(forKey: "answer") as! String
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyThings", for: indexPath)

        cell.textLabel?.text = questions[indexPath.row]
        
        let switchView = UISwitch(frame: .zero)
        
        let currentAnswer = dailyData[indexPath.row].answer
        
        if (currentAnswer == "Y"){
            switchView.setOn(true,animated: true)
        }
        else{
            switchView.setOn(false, animated: true)
        }
        
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    //检测switcher是否发生改变
    @objc func switchChanged(_ sender : UISwitch!) -> Void {
        
        dailyData[sender.tag].answer = (sender.isOn ? "Y":"N")
        
        uploadToSql(question: sender.tag, answer: dailyData[sender.tag].answer)
        
        if (sender.isOn ){
            Figure.carReduce -= 5
        }
        else{
            Figure.carReduce += 5
        }
        
        dataManger.saveDataToFile(dataList: dailyData, pathToFile: DailyThing.ArchiveURL.path)
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
