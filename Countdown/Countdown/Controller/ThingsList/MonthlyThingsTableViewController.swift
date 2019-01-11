//
//  TodayTableViewController.swift
//  Countdown
//
//  Created by apple on 2018/11/25.
//  Copyright © 2018年 nju. All rights reserved.
//

import UIKit
import InputKitSwift

@IBDesignable
class TodayTableViewController: UITableViewController {

    //Declare the monthly things
    
    var thingData:[String] = []
    
    var tipData:[String] = []
    
    var dict:NSMutableDictionary!
    
    var notesArray:NSMutableArray!
    
    var plistPath:String!
    
    var monthlyData:[MonthlyThing] = []
    
    var defaults = UserDefaults.standard
    
    var time = Time()
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        dict = NSMutableDictionary(contentsOfFile: plistPath!)
        
        thingData = dict!.object(forKey: "Thing") as! [String]
        
        tipData = dict!.object(forKey: "Tip") as! [String]
        
        initData()
        
    }
    
    func initData(){
        let dataManager = DataManager(filePath: MonthlyThing.ArchiveURL.path)
        
        if (monthlyData.count==0){
            print ("Monthly Data: Load from file")
            if let preData = dataManager.loadDataFromFile(pathToFile: MonthlyThing.ArchiveURL.path){
                monthlyData = preData as! [MonthlyThing]
            }else{
                loadDataFromSql()
                if (monthlyData.count == 0){
                    let time = Time()
                    let curTime = time.getCurrentTime(currentDate: Date())
                    for i in 0...thingData.count-1{
                        monthlyData.append(MonthlyThing(thing: String(i),amount: "0",mail: defaults.string(forKey: "currentMail") ?? "default@mail",date: curTime))
                    }
                }
            }
        }
        
        dataManager.saveDataToFile(dataList: monthlyData, pathToFile: MonthlyThing.ArchiveURL.path)
        for i in 0...monthlyData.count-1{
            uploadToSql(thingNum: i, amount: monthlyData[i].amount)
        }
    }
    func loadDataFromSql(){
        let queryService = QueryService()
        queryService.httpRequest(request: queryService.getAllMonthlyDataRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: defaults.string(forKey: "currentDate") ?? time.getCurrentTime(currentDate: Date())))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                
                let dataAfter = data.data(using: String.Encoding.utf8)
                let jsonDic = try! JSONSerialization.jsonObject(with: dataAfter!,                                         options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let dataValue = jsonDic.value(forKey: "data") as! NSArray
                for item in dataValue{
                    let item = item as! NSDictionary
                    self.monthlyData[item.value(forKey: "thing") as! Int].amount = item.value(forKey: "amount") as! String
                }
                //print ("Initial load data",self.monthlyData)
            }
        }
    }
    func uploadToSql(thingNum:Int,amount:String){
        let queryService = QueryService()
        queryService.httpRequest(request: queryService.updateSingleMonthlyDataRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: defaults.string(forKey: "currentDate") ?? time.getCurrentTime(currentDate: Date()),thingNum: thingNum, amount: amount))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                //print("upload single Monthly :",data)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initData()
        
    }
    override func viewDidLoad() {
        
        initData()
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //let firstArray = notesArray.object(at: 0) as! Array<String>
        //return firstArray.count
        return thingData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)

        cell.textLabel!.text = thingData[indexPath.row]
        cell.detailTextLabel!.text = String(monthlyData[indexPath.row].amount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alert(currentRow: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //Mark:弹出框，来修改数据
    func alert (currentRow cRow: IndexPath){
        let currentTip = tipData[cRow.row]
        
        let alertController = UIAlertController(title: currentTip, message: " ", preferredStyle: .alert)
        
        alertController.addTextField { (textField:UITextField) -> Void in
            
            textField.placeholder = "请输入数字..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction (title: "Confirm", style: .default) { (action) in
            
            let amount = alertController.textFields![0]
            
            if (self.isValidInput(string: amount.text!)){
                self.refresh(currentRow: cRow, amount: ((amount.text)! as NSString).floatValue)
            }
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController,animated: true,completion: nil)
        
    }
    
    func isValidInput(string:String) -> Bool{
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
            for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char < 48 && char != 46 {return false }
            if char > 57 && char != 46 {return false }
        }
        return true
    }
    
    //更新所有数据
    func refresh(currentRow cRow:IndexPath,amount toChange:Float)
    {
        let MT = MonthlyThing.ArchiveURL.path
        
        let dataManager = DataManager(filePath:MT)
    
        
        let before = Float(monthlyData[cRow.row].amount) ?? 0.0
        
        //更新Carbon reduce
        if (cRow.row == 2){
            //
            let carBefore = getInitialDoc(index: 7)
            let carAfter = toChange
            let oilPerHundMile = getInitialDoc(index: 4)
            if (carBefore != 0.0 && oilPerHundMile != 0.0){
                Figure.carReduce += Double((carBefore-carAfter)*oilPerHundMile/100*(2.7-0.036) * 0.07)
                
            }
            print (Figure.carReduce)
        }
        else if (cRow.row == 1){
            let elecBefore = getInitialDoc(index:6)
            let elecAfter = toChange
            if (elecBefore != 0.0){
                Figure.carReduce += Double((elecBefore-elecAfter)*0.785*0.07)
            }
            print (Figure.carReduce)
        }
        else if (cRow.row == 0){
            let waterBefore = getInitialDoc(index:5)
            let waterAfter = toChange
            if (waterBefore != 0.0){
                Figure.carReduce += Double((waterBefore-waterAfter)*0.91*0.07)
            }
            print (Figure.carReduce)
        }else if (cRow.row == 3){
            //回收废纸
            Figure.carReduce -= Double(1.534/120 * (toChange-before))
        }else if (cRow.row == 4){
            //回收废旧塑料
            Figure.carReduce -= Double(1.6/120 * (toChange - before))
        }else if (cRow.row == 5){
            //回收废金属
            Figure.carReduce -= Double(2.13/120 * (toChange - before))
        }
        monthlyData[cRow.row].amount = String(toChange)
        
        dataManager.saveDataToFile(dataList: monthlyData, pathToFile: MT)
        
        uploadToSql(thingNum: cRow.row, amount: String(toChange))
        
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    func getInitialDoc(index:Int) -> Float{
        if let temp = defaults.string(forKey: "initialDoc-"+String(index)){
            let doubleValue = (temp as NSString).floatValue
            return doubleValue
            
        }
        return 0.0
    }
}
