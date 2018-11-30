//
//  ProfileTableViewController.swift
//  Countdown
//
//  Created by mac on 11/28/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
@IBDesignable
class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var myHeadhot: UIImageView!
    
    let name:[String] = ["历史贡献","我的设备"]
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var sign: UILabel!
    
    override func viewDidLoad() {
        nickName.text = "CAQ"
        sign.text = "stszz"
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
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneLable", for: indexPath)

        // Configure the cell...
        let label = cell.viewWithTag(1) as! UILabel
        label.text = name[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //拿到storyBoard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //拿到ViewController
        let equipmentsPage = storyBoard.instantiateViewController(withIdentifier:"MyEquipments") as! MyEquipmentsTableViewController
        //传值
        // nextPage.id = joinUsDataArray[indexPath.row].id
        // nextPage.titleOfNavi.title = joinUsDataArray[indexPath.row].title
        //跳转
        //self.navigationController?.pushViewController(nextPage, animated: true)
        let historyPage = storyBoard.instantiateViewController(withIdentifier:"History") as! HistoryTableViewController
        
        if indexPath.row == 0{
            self.navigationController?.pushViewController(historyPage, animated: true)
        }
        else{
            self.navigationController?.pushViewController(equipmentsPage, animated: true)
        }
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
