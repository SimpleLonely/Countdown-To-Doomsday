//
//  TodayTableViewController.swift
//  Countdown
//
//  Created by apple on 2018/11/25.
//  Copyright © 2018年 nju. All rights reserved.
//

import UIKit


class TodayTableViewController: UITableViewController {

    //Declare the monthly things
    var items: [SimpleCellItem]
    
    var thingData:[String]
    
    var amountData:[Float32]
    
    //init the monthly things
    required init?(coder aDecoder: NSCoder) {
        items = [SimpleCellItem]()
        
        let row0 = SimpleCellItem()
        row0.name = "用水量"
        row0.amount = "35L"
        row0.tip = "本月的用水量是："
        items.append(row0)
        
        let row1 = SimpleCellItem()
        row1.name = "用电量"
        row1.amount = "35度"
        row1.tip = "本月的用电量是："
        items.append(row1)
        
        let path = Bundle.main.path(forResource:"MonthlyThingsDataList",ofType:"plist")
        
        let dict = NSDictionary(contentsOfFile: path!)
        
        thingData = dict!.object(forKey: "Thing") as! [String]
        
        amountData = dict!.object(forKey: "Amount") as! [Float32]
        
        super.init(coder: aDecoder)
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
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)

        //let item = items[indexPath.row]
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = thingData[indexPath.row]
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = String (amountData[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
