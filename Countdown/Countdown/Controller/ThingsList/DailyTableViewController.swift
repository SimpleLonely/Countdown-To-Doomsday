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
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.dailyThingsPlistPathInDocument
        
        dict = NSMutableDictionary(contentsOfFile: plistPath!)
        
        questions = dict!.object(forKey: "questions") as! [String]

        
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
    
    override func viewDidLoad() {
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
    
    @objc func switchChanged(_ sender : UISwitch!) -> Void {
        //print("table row switch Changed \(sender.tag)")
        //print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        dailyData[sender.tag].answer = (sender.isOn ? "Y":"N")
        
        uploadToSql(question: sender.tag, answer: dailyData[sender.tag].answer)
        
        dataManger.saveDataToFile(dataList: dailyData, pathToFile: DailyThing.ArchiveURL.path)
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //弹出框，来修改数据
    /*func alert (currentRow cRow: IndexPath){
        let currentTip = tipData[cRow.row]
        
        let alertController = UIAlertController(title: currentTip, message: " ", preferredStyle: .alert)
        
        alertController.addTextField { (textField:UITextField) -> Void in
            textField.placeholder = "请输入..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction (title: "Confirm", style: .default) { (action) in
            
            let amount = alertController.textFields![0]
            
            self.refresh(currentRow: cRow, amount: ((amount.text)! as NSString).floatValue)
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController,animated: true,completion: nil)
        
    }
    */
    
    //更新所有数据
    /*func refresh(currentRow cRow:IndexPath,amount toChange:Float)
    {
        // let path = Bundle.main.path(forResource:"MonthlyThingsDataList",ofType:"plist")
        
        // let dict = NSDictionary(contentsOfFile: path!)
        
        amountData[cRow.row] = toChange
        
        // let dicString = dict?.allKeys as! [String]
        
        dict?.setValue(amountData, forKey: "Amount")
        
        dict?.write(toFile: plistPath!, atomically: true)
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }*/
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
