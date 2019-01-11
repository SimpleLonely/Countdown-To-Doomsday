//
//  MyEquipmentsTableViewController.swift
//  Countdown
//
//  Created by mac on 11/29/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit


class InitialDocTableViewController: UITableViewController,levelDelegte,typeDelegte{
    
    var titles:[[String]] = [[],[],[],[],[],[]]
    
    var details:[[String]] = [[],[],[],[],[],[]]
    
    let sectionTitles = ["能源等级","种类","升数","","回收",""]
    
    var dict:NSMutableDictionary!
    
    var plistPath:String = String()
    
    let defaults = UserDefaults.standard
    
    func prepareInitialDoc(n:Int){
        
        for i in 0...n-1{
            defaults.set("To completed..", forKey: "initialDoc-"+String(i))
        }
    }
    
    //Declare the monthly things
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        plistPath = appDelegate.initialDocPath
        
        dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        
        let tempString = dict!.object(forKey: "Equipments") as! [String]
        
        
        titles = [[],[],[],[],[],[]]
        
        details = [[],[],[],[],[],[]]
        titles[0].append(tempString[0])
        titles[0].append(tempString[1])
        
        titles[1].append(tempString[2])
        
        titles[2].append(tempString[3])
        titles[2].append(tempString[4])
        
        titles[3].append(tempString[5])
        titles[3].append(tempString[6])
        titles[3].append(tempString[7])
        
        titles[4].append(tempString[8])
        titles[4].append(tempString[9])
        titles[4].append(tempString[10])
        titles[4].append(tempString[11])
        
        var tempDetails:[String] = []
        //如果应用第一次启动，将initdoc初始化
        for i in 0...tempString.count-1{
            if let cur = defaults.string(forKey: "initialDoc-"+String(i)){
                 tempDetails.append(cur)
            }
            else{
                defaults.set("To complete..", forKey:"initialDoc-"+String(i))
                tempDetails.append("To complete..")
            }
            
        }
        
        details[0].append(tempDetails[0]+"级")
        details[0].append(tempDetails[1]+"级")
        
        details[1].append(tempDetails[2])
        
        details[2].append(tempDetails[3]+"升")
        details[2].append(tempDetails[4]+"升")
        
        details[3].append(tempDetails[5]+"升")
        details[3].append(tempDetails[6]+"度")
        details[3].append(tempDetails[7]+"公里")
        
        details[4].append(tempDetails[8]+"千克")
        details[4].append(tempDetails[9]+"千克")
        details[4].append(tempDetails[10]+"千克")
        details[4].append(tempDetails[11]+"千克")
    }
    //更新种类
    func refresh(type: String, indexPath: IndexPath) {
        details[indexPath.section][indexPath.row] = type
        
        var s=0
        
        for i in 0...indexPath.section{
            if i==indexPath.section{
                s+=indexPath.row
            }
            else{
                s+=details[i].count
            }
        }
        
        defaults.set(type, forKey: "initialDoc-"+String(s))
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
        
    }
    //更新能源等级
    func refresh(level: Int, indexPath: IndexPath) {
        
        var s=0
        
        for i in 0...indexPath.section{
            if i==indexPath.section{
                s+=indexPath.row
            }
            else{
                s+=details[i].count
            }
        }
        
        defaults.set(level, forKey: "initialDoc-"+String(s))
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
        
    }
    
    //更新数据
    func refresh(currentRow indexPath:IndexPath,toChange c:String)
    {
        var s=0
        
        for i in 0...indexPath.section{
            if i==indexPath.section{
                s+=indexPath.row
            }
            else{
                s+=details[i].count
            }
        }
        
        details[indexPath.section][indexPath.row] = c
        
        defaults.set(c, forKey: "initialDoc-"+String(s))
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    

    // 設置每個 section 的 title 為一個 UIView
    // 如果實作了這個方法 會蓋過單純設置文字的 section title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  sectionTitles[section]
    }
    
    
    // 設置 section header 的高度
    override func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 27
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
        return titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipCell", for: indexPath)

        let label = cell.textLabel
        label!.text = titles[indexPath.section][indexPath.row]
        
        let detail = cell.detailTextLabel
        detail?.text = details[indexPath.section][indexPath.row]
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //拿到storyBoard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //拿到ViewController
        //传值
        
        
        if (indexPath.section == 0){
            let equipmentPage = storyBoard.instantiateViewController(withIdentifier:"Equipment1") as! Equipment1TableViewController
            //equipmentPage.title? = titles[indexPath.section][indexPath.row]
            equipmentPage.currentIndexPath = indexPath
            equipmentPage.delegate = self
            
            //跳转到五级界面
            self.navigationController?.pushViewController(equipmentPage, animated: true)
        }
        else if (indexPath.section == 1){
            let equipmentPage2 = storyBoard.instantiateViewController(withIdentifier:"Equipment2") as! Equipment2TableViewController
            equipmentPage2.currentIndexPath = indexPath
            equipmentPage2.delegate2 = self
            self.navigationController?.pushViewController(equipmentPage2, animated: true)
        }
        else{
            alert(currentRow: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //弹出框，来修改数据
    func alert (currentRow cRow: IndexPath){
        let currentTip = ""
        
        let alertController = UIAlertController(title: currentTip, message: " ", preferredStyle: .alert)
        
        alertController.addTextField { (textField:UITextField) -> Void in
            textField.placeholder = "请输入..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction (title: "Confirm", style: .default) { (action) in
            
            let amount = alertController.textFields![0]
            if (self.isValidInput(string: amount.text!)){
                self.refresh(currentRow: cRow, toChange: amount.text!)
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

}
