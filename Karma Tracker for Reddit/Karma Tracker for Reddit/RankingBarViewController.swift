//
//  RankingBarViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit
import Charts

class RankingBarViewController: UIViewController, IAxisValueFormatter, ChartViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var sourceType: KarmaSource?
    var top5: ArraySlice<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarChart()
    }
    
    func setUpBarChart() {
        var array: [AccountElement]?
        
        switch sourceType! {
        case .comments:
            titleLabel.text = "Top Subreddits for Comments"
            array = SharedData.shared.getComments()
        case .posts:
            titleLabel.text = "Top Subreddits for Posts"
            array = SharedData.shared.getSubmissions()
        }

        if let array = array {
            var dictionary = [String:Int]()
            for element in array {
                let sum = dictionary[element.subreddit] ?? 0
                dictionary[element.subreddit] = sum + element.score
            }
            var subredditSet = Array(dictionary.keys)
            subredditSet = subredditSet.sorted(by: {
                (first: String, second: String) -> Bool in
                let firstCount = dictionary[first]
                let secondCount = dictionary[second]
                return firstCount! > secondCount!
            })
            var barChartDataEntries = [BarChartDataEntry]()
            self.top5 = subredditSet[0..<(min(5, subredditSet.count))]
            for i in 0..<top5!.count {
                let entry = BarChartDataEntry(x: Double(i), y: Double(dictionary[subredditSet[i]]!))
                barChartDataEntries.append(entry)
                
            }
            let barChartDataSet = BarChartDataSet(values: barChartDataEntries, label: "\(sourceType!) points")
            barChartDataSet.colors = [(sourceType == .posts) ? UIColor.black : UIColor.gray]
            
            let barChartData = BarChartData(dataSet: barChartDataSet)

            barChartView.data = barChartData
            barChartView.chartDescription = nil
            barChartView.rightAxis.enabled = false
            barChartView.xAxis.labelPosition = .bottom
            barChartView.xAxis.labelRotationAngle = 0
            barChartView.xAxis.valueFormatter = self
            barChartView.xAxis.granularity = 1
            barChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInBack)
            barChartView.xAxis.yOffset = 0
            barChartView.xAxis.gridLineWidth = 0
            barChartView.delegate = self
        }
        
        barChartView.layer.borderColor = UIColor.black.cgColor
        barChartView.layer.borderWidth = 1
    }

    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the x-axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        return "\(Int(value) + 1)"
    }
    
    /// Called when a value has been selected inside the chart.
    /// - parameter entry: The selected Entry.
    /// - parameter highlight: The corresponding highlight object that contains information about the highlighted position such as dataSetIndex etc.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedLabel.text = top5![Int(entry.x)]
    }

}
