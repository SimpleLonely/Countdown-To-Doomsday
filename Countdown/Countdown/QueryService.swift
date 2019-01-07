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
    
    public func getHistoryItem(request: URLRequest!, callback: @escaping (String, String?) -> Void){
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
    
}
