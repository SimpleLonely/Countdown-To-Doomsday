//
//  ProfileTableViewController.swift
//  Countdown
//
//  Created by mac on 11/28/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import Auth0

@IBDesignable
class ProfileTableViewController: UITableViewController {
    
    // Create an instance of the credentials manager for storing credentials
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    var profile:UserInfo!
    
    @IBOutlet weak var myHeadhot: UIImageView!
    
    let name:[String] = ["我的账户","历史贡献","初始档案"]
    
    let defaults = UserDefaults.standard
    
    @IBAction func tapMine(_ sender: Any) {
        
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
        return name.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneLable", for: indexPath)

        // Configure the cell...
        let label = cell.textLabel
        label!.text = name[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
        let equipmentsPage = storyBoard.instantiateViewController(withIdentifier:"MyEquipments") as! InitialDocTableViewController
        
        let historyPage = storyBoard.instantiateViewController(withIdentifier:"History") as! HistoryTableViewController
        
        let myProfilePage = storyBoard.instantiateViewController(withIdentifier: "MyProfilePage") as! MyProfileSettingViewController
        
        switch indexPath.row {
        case 0:
            if defaults.bool(forKey: "loginStatus"){
            self.navigationController?.pushViewController(myProfilePage, animated: true)
            }
            else{
                showLoginPage()
                self.navigationController?.pushViewController(myProfilePage, animated: true)
            }
            break
        case 1:
            self.navigationController?.pushViewController(historyPage, animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(equipmentsPage, animated: true)
        default:
            print ("outOfIndex")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func showLoginPage(){
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://simple-lin.au.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    self.defaults.set(true,forKey: "loginStatus")
                    self.defaults.set(credentials.idToken, forKey: "currentMail")
                    if (!SessionManager.shared.store(credentials: credentials)){
                        print ("Failed to store credentials")
                    }
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return self.showLoginPage()
                            }
                            //self.performSegue(withIdentifier: "MyProfilePage", sender: nil)
                        }
                    }
                
                }
        }
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
