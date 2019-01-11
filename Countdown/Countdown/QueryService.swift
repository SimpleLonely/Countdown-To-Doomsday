//
//  QueryService.swift
//  Countdown
//
//  Created by mac on 1/7/19.
//  Copyright © 2019 nju. All rights reserved.
//

import Foundation
class QueryService{
    static let baseURL = "http://47.106.153.201:8080/"
    
    static func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    public func httpRequest(request: URLRequest!, callback: @escaping (String, String?) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    String.Encoding.ascii.rawValue)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    public func getHistoryRequest(mail:String) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"get-all-history")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
        ]
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
        /*httpRequest(request: request){
            (data, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                //TODO: decode to json
                //TODO: return to main
                print(data)
            }
        }*/
    }
    
    public func addHistoryItemRequest(mail:String,date:String,amount:String) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"add-history")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "amount", value: amount)
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
        /*httpRequest(request: request){
            (data, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                print(data)
            }
        }*/
    }
    
    public func getAllMonthlyDataRequest(mail:String,date:String ) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"get-all-monthly-by-date")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date)
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
    public func getSingleMonthlyDataRequest(mail:String,date:String,thingNum thing:Int ) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"get-monthly-single-amount")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name:"thing",value: String(thing))
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
    public func updateSingleMonthlyDataRequest(mail:String,date:String,thingNum thing:Int,amount:String ) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"update-monthly-single-amount")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name:"thing",value: String(thing)),
            URLQueryItem(name: "amount", value: amount)
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }
    
    public func updateDailyDataRequest(mail:String,date:String,question:Int,answer:String) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"update-answer")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name:"question",value: String(question)),
            URLQueryItem(name: "answer", value: answer)
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }
    
    public func getAllDailyDataRequest(mail:String,date:String) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"get-all-answer")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date)
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
    
    public func getSingleDailyDataRequest(mail:String,date:String,question:Int) -> URLRequest{
        var components = URLComponents(string: QueryService.baseURL+"get-single-answer")!
        components.queryItems = [
            URLQueryItem(name: "mail", value: mail),
            //TODO: add inspector to the date and mail
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "question", value: String(question))
        ]
        
        var request = URLRequest (url: components.url!)
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
}
