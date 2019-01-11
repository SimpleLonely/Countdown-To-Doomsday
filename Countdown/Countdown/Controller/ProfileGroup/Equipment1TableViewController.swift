//
//  Equipment1TableViewController.swift
//  Countdown
//
//  Created by mac on 11/30/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit

protocol levelDelegte : NSObjectProtocol{
    //在协议里面，声明刷新方法
    func refresh(level:Int,indexPath:IndexPath)
    
}

class Equipment1TableViewController: UITableViewController {

    var data:[String] = []
    
    var delegate:levelDelegte?
    
    var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        data = ["没有该设备","一级","二级","三级","四级","五级"]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath)

        let label = cell.textLabel
        label?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate!.refresh(level:indexPath.row,indexPath: currentIndexPath!)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
