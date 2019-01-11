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
        
        loadDataFromSql()
        if (monthlyData.count==0){
            print ("Load from file")
            if let preData = dataManager.loadDataFromFile(pathToFile: MonthlyThing.ArchiveURL.path){
                monthlyData = preData as! [MonthlyThing]
            }else{
                let time = Time()
                let curTime = time.getCurrentTime(currentDate: Date())
                for i in 0...thingData.count-1{
                    monthlyData.append(MonthlyThing(thing: String(i),amount: "0",mail: defaults.string(forKey: "currentMail") ?? "default@mail",date: curTime))
                }
            }
        }
        
        
        dataManager.saveDataToFile(dataList: monthlyData, pathToFile: MonthlyThing.ArchiveURL.path)
        //TODO: add async
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

        //let item = items[indexPath.row]
        
        //let label1 = cell.textLabel
        //label1?.text = thingData[indexPath.row]
        
        //let label2 = cell.detailTextLabel
        //label2?.text = String (amountData[indexPath.row])
        //let firstArray = notesArray.object(at: 0) as! Array<String>
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
    
        monthlyData[cRow.row].amount = String(toChange)
        
        dataManager.saveDataToFile(dataList: monthlyData, pathToFile: MT)
        
        uploadToSql(thingNum: cRow.row, amount: String(toChange))
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
