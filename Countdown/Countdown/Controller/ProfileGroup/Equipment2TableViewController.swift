//
//  Equipment2TableViewController.swift
//  Countdown
//
//  Created by mac on 12/3/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit

protocol typeDelegte : NSObjectProtocol{
    //在协议里面，声明刷新
    func refresh(type:String,indexPath:IndexPath)
    
}
//只针对灯具类型
class Equipment2TableViewController: UITableViewController {

    var data:[String] = []
    
    var delegate2:typeDelegte!
    
    var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        data = ["没有该设备","LED","白炽灯"]
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
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
        
        let label = cell.textLabel
        label?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate2!.refresh(type:data[indexPath.row],indexPath: currentIndexPath!)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
