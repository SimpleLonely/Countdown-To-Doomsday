//
//  HistoryTableViewController.swift
//  Countdown
//
//  Created by mac on 11/30/18.
//  Copyright © 2018 nju. All rights reserved.
//

import UIKit
import Charts


class HistoryTableViewController: UITableViewController {

    var date:[String]
    
    var data:[Int]
    
    required init?(coder aDecoder: NSCoder) {
        let path = Bundle.main.path(forResource:"HistoryPropertyList",ofType:"plist")
        
        let dict = NSDictionary(contentsOfFile: path!)
        
        date = dict!.object(forKey: "Date") as! [String]
        
        data = dict!.object(forKey: "Data") as! [Int]
        
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var barChartView: BarChartView!
    
    //设置表格的相关属性
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
            let value = data[i]
            let entry = BarChartDataEntry(x:Double(i),y:Double(value))
            values.append(entry)
        }
        
        let set = BarChartDataSet(values: values, label: "prec")
        set.barBorderWidth = 0
        
        let datas = BarChartData(dataSet: set)
        datas.setDrawValues(true)
        barChartView.data=datas
        
    }
    
    override func viewDidLoad() {
        
        let path = Bundle.main.path(forResource:"HistoryPropertyList",ofType:"plist")
        
        let dict = NSDictionary(contentsOfFile: path!)
        
        date = dict!.object(forKey: "Date") as! [String]
        
        data = dict!.object(forKey: "Data") as! [Int]
        
        setChart(withCount: data.count)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

        let label = cell.textLabel
        label?.text = date[indexPath.row]
        
        let detail = cell.detailTextLabel
        detail?.text = String(data[indexPath.row])
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
