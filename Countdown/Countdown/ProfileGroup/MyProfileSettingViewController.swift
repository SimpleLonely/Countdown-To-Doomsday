//
//  MyProfileSettingViewController.swift
//  Countdown
//
//  Created by mac on 12/29/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit

class MyProfileSettingViewController: UIViewController {

    let userDefault = UserDefaults.standard
    @IBOutlet weak var nickName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogOut(_ sender: Any) {
        userDefault.set(false, forKey: "loginStatus")
        
    }
    @IBOutlet weak var introduction: UILabel!
    
    @IBAction func modifyName(_ sender: Any) {
        alert(tip: "请修改")
    }
    func alert (tip currentString:String){
        
        let alertController = UIAlertController(title: currentString, message: " ", preferredStyle: .alert)
        
        alertController.addTextField { (textField:UITextField) -> Void in
            textField.placeholder = self.nickName.text!
        }
        alertController.addTextField { (textField:UITextField) -> Void in
            textField.placeholder = self.introduction.text!
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction (title: "Confirm", style: .default) { (action) in
            
            self.nickName.text = alertController.textFields![0].text
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController,animated: true,completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
