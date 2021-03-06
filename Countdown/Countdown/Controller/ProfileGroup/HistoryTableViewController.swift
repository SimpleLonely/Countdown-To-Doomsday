//
//  HistoryTableViewController.swift
//  Countdown
//
//  Created by mac on 11/30/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import Charts
import os.log

//以天为单位记录
class HistoryTableViewController: UITableViewController {

    var dict:NSMutableDictionary!
    
    var plistPath:String = String()
    
    var data:[String] = []
    
    var date:[String] = []
    
    var historyData = [HistoryData]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var barChartView: BarChartView!
    
    let dataManager = DataManager(filePath: HistoryData.ArchiveURL.path)
    
    
    //MARK:设置表格的相关属性
    func setChart(withCount count:Int){
        barChartView.noDataText = "You have not any contributions."
        
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.drawGridBackgroundEnabled = true
        barChartView.dragEnabled = true
        barChartView.maxVisibleCount = 60
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = IAxisValueFormatter(chart: barChartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        var values = [BarChartDataEntry]()
        for i in 0..<count{
            //设置数据
            let value = historyData[i].amount
            let entry = BarChartDataEntry(x:Double(i),y:Double(value) ?? 0.0)
            values.append(entry)
        }
        
        let set = BarChartDataSet(values: values, label: "prec")
        set.barBorderWidth = 0
        
        let datas = BarChartData(dataSet: set)
        datas.setDrawValues(true)
        barChartView.data=datas
        
    }
    //MARK: 更新/添加一条历史记录
    //默认以当前时间和当前用户
    func addItemToSql(data:String){
        let queryService = QueryService()
        let time = Time()
        queryService.httpRequest(request: queryService.addHistoryItemRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail", date: defaults.string(forKey: "currentDate") ?? time.getCurrentTime(currentDate: Date()),amount:data))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                print("add history item:",data)
            }
        }}
    
    //从服务器获取数据列表
    func loadFromSql(){
        let queryService = QueryService()
        let time = Time()
        queryService.httpRequest(request: queryService.getHistoryRequest(mail: defaults.string(forKey: "currentMail") ?? "default@mail"))
        { (data,error) -> Void in
            if error != nil {
                print(error!)
            } else {
                let dataAfter = data.data(using: String.Encoding.utf8)
                let jsonDic = try! JSONSerialization.jsonObject(with: dataAfter!,                                         options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                var dataValue = NSArray()
                if let temp = jsonDic.value(forKey: "data") as? NSArray{
                    dataValue = temp
                    self.historyData = []
                    for item in dataValue{
                        let item = item as! NSDictionary
                        self.historyData.append(HistoryData(date: item.value(forKey: "date") as! String, amount: item.value(forKey: "amount") as! String, mail: self.defaults.string(forKey: "currentMail") ?? "default@mail"))
                        
                    }
                    self.dataManager.saveDataToFile(dataList: self.historyData, pathToFile: HistoryData.ArchiveURL.path)
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initData()
        setChart(withCount: historyData.count)
    }
    
    //初始设置数据
    func initData(){
        
        let time = Time()
        if let temp = dataManager.loadDataFromFile(pathToFile: HistoryData.ArchiveURL.path) {
            historyData =  temp as! [HistoryData]
        }
        if historyData.count == 0{
            loadFromSql()
        }
        if historyData.count == 0{
            addItemToSql(data: "0")
            historyData.append(HistoryData(date: time.getCurrentTime(currentDate: Date()), amount: "0", mail: defaults.string(forKey: "currentMail") ?? "default@mail"))
        }
        
        dataManager.saveDataToFile(dataList: historyData, pathToFile: HistoryData.ArchiveURL.path)
        
    }
    override func viewDidLoad() {
        
        initData()
        
        setChart(withCount: historyData.count)
        
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return historyData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

        let label = cell.textLabel
        label?.text = historyData[indexPath.row].date
        
        let detail = cell.detailTextLabel
        detail?.text = String(historyData[indexPath.row].amount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
