//
//  AppDelegate.swift
//  Countdown
//
//  Created by apple on 2018/11/21.
//  Copyright © 2018年 nju. All rights reserved.
//

import UIKit
import Auth0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var monthlyThingsPlistPathInDocument:String = String()
    
    var dailyThingsPlistPathInDocument:String = String()
    
    var initialDocPath:String = String()
    
    var historyDocPath:String = String()
    
    let defaults = UserDefaults.standard
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return Auth0.resumeAuth(url, options: options)
    }
    
    
    func prepareMonthlyThingsPlistForUse(){
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        monthlyThingsPlistPathInDocument = rootPath.appendingFormat("/MonthlyThingsDataList.plist")
        if !FileManager.default.fileExists(atPath: monthlyThingsPlistPathInDocument){
            let plistPathInBundle = Bundle.main.path(forResource: "MonthlyThingsDataList", ofType: "plist")
            // 3
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: monthlyThingsPlistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    func prepareDailyThingsPlistForUse(){
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        dailyThingsPlistPathInDocument = rootPath.appendingFormat("/DailyThingsDataList.plist")
        if !FileManager.default.fileExists(atPath: dailyThingsPlistPathInDocument){
            let plistPathInBundle = Bundle.main.path(forResource: "DailyThingsDataList", ofType: "plist")
            // 3
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: dailyThingsPlistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    func prepareInitialDocForUse(){
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        initialDocPath = rootPath.appendingFormat("/InitialDataList.plist")
        if !FileManager.default.fileExists(atPath: monthlyThingsPlistPathInDocument){
            let plistPathInBundle = Bundle.main.path(forResource: "InitialDataList", ofType: "plist")
            // 3
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: initialDocPath)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.prepareInitialDocForUse()
        self.prepareMonthlyThingsPlistForUse()
        self.prepareDailyThingsPlistForUse()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.prepareInitialDocForUse()
        self.prepareMonthlyThingsPlistForUse()
        self.prepareDailyThingsPlistForUse()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
    }


}

