//
//  TodayTableViewController.swift
//  Countdown
//
//  Created by apple on 2018/11/25.
//  Copyright © 2018年 nju. All rights reserved.
//

import UIKit

@IBDesignable
class TodayTableViewController: UITableViewController {

    //Declare the monthly things
    
    var thingData:[String] = []
    
    //TODO: Change to [String] and change below usages
    var amountData:[Float32] = []
    
    var tipData:[String] = []
    
    var dict:NSMutableDictionary!
    
    var notesArray:NSMutableArray!
    
    var plistPath:String!
    
    var initialPath:String!
    
    var initialDict:NSMutableDictionary!
    
    var monthlyData:[MonthlyThing] = []
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        
        //TODO:Change data format
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        dict = NSMutableDictionary(contentsOfFile: plistPath!)
        
        thingData = dict!.object(forKey: "Thing") as! [String]
        
        amountData = dict!.object(forKey: "Amount") as! [Float32]
        
        tipData = dict!.object(forKey: "Tip") as! [String]
        
        initialPath = appDelegate.initialDocPath
        
        initialDict = NSMutableDictionary(contentsOfFile: initialPath!)
        
        var initialString = initialDict.object(forKey: "Data") as! [String]
        
        //TODO: Load from sql
        
        for i in 0...thingData.count-1{
            monthlyData.append(MonthlyThing(thing: thingData[i], amount: String(amountData[i]), tip: tipData[i]))
        }
        let dataManager = DataManager(filePath: MonthlyThing.ArchiveURL.path)
        //var monthlyData = dataManager.loadDataFromFile(pathToFile: MonthlyThing.ArchiveURL.path) as! [MonthlyThing]
        dataManager.saveDataToFile(dataList: monthlyData, pathToFile: MonthlyThing.ArchiveURL.path)
        
        //将本月的数据默认设为历史数据
        
        /*amountData[0] = (initialString[5] as NSString).floatValue
        
        amountData[1] = (initialString[6] as NSString).floatValue
        
        amountData[3] = (initialString[7] as NSString).floatValue
        
        dict?.setValue(amountData, forKey: "Amount")
        
        dict?.write(toFile: plistPath!, atomically: true)*/
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.monthlyThingsPlistPathInDocument
        
        
        dict = NSMutableDictionary(contentsOfFile: plistPath!)
        
        thingData = dict!.object(forKey: "Thing") as! [String]
        
        amountData = dict!.object(forKey: "Amount") as! [Float32]
        
        tipData = dict!.object(forKey: "Tip") as! [String]
        
        
        self.tableView.reloadData()
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
        cell.detailTextLabel!.text = String(amountData[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alert(currentRow: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //弹出框，来修改数据
    func alert (currentRow cRow: IndexPath){
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
    
    
    //更新所有数据
    func refresh(currentRow cRow:IndexPath,amount toChange:Float)
    {
        // let path = Bundle.main.path(forResource:"MonthlyThingsDataList",ofType:"plist")
        
        // let dict = NSDictionary(contentsOfFile: path!)
        
        amountData[cRow.row] = toChange
        
        // let dicString = dict?.allKeys as! [String]
        
        dict?.setValue(amountData, forKey: "Amount")
        
        dict?.write(toFile: plistPath!, atomically: true)
        
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