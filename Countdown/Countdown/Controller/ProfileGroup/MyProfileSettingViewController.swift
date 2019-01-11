//
//  MyProfileSettingViewController.swift
//  Countdown
//
//  Created by mac on 12/29/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import Auth0

class MyProfileSettingViewController: UIViewController {

    @IBOutlet weak var mail: UILabel!
    let userDefault = UserDefaults.standard
    @IBOutlet weak var nickName: UILabel!
    var profile:UserInfo?
    
    override func viewDidLoad() {
        //因为登陆后的异步请求所以遗留了刷新方面的问题。。
        profile = SessionManager.shared.profile
        if let temp = profile{
            nickName.text = temp.name
            mail.text = userDefault.string(forKey: "currentMail")
        }
        else{
            nickName.text = "Guest"
            mail.text = "点击修改，添加默认邮箱"
        }
        super.viewDidLoad()

    }
    
    @IBAction func LogOut(_ sender: Any) {
        userDefault.set(false, forKey: "loginStatus")
        _ = SessionManager.shared.logout()
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var introduction: UILabel!
    
    @IBAction func modifyName(_ sender: Any) {
        alert(tip: "请修改您的昵称或邮箱")
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
            
            self.nickName.text = (alertController.textFields![0].text == "" ? self.nickName.text:alertController.textFields![0].text)
            
            
            self.introduction.text = (alertController.textFields![1].text == "" ? self.introduction.text:alertController.textFields![1].text)
            
            self.userDefault.set(self.introduction.text ?? "default@mail", forKey: "currentMail")
            
            
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(confirmAction)
        
        self.present(alertController,animated: true,completion: nil)
        
    }

}
