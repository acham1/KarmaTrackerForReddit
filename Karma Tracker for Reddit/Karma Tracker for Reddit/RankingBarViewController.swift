//
//  RankingBarViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/21/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit
import Charts

/// View controller that shows a bar chart ranking top subreddits contributing points to user account
class RankingBarViewController: UIViewController, IAxisValueFormatter, ChartViewDelegate {

    @IBOutlet weak var titleLabel: UILabel! // title label of the view
    @IBOutlet weak var selectedLabel: UILabel!  // label showing current selected bar
    @IBOutlet weak var barChartView: BarChartView!  // featured iOS bar chart view
    var sourceType: KarmaSource?    // the sourceType this plot is showing (i.e. comments or posts)
    var top5: ArraySlice<String>?   // top five subreddits to plot
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarChart()
    }

    /// set chart properties and load data
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

            // set up chart appearance
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
            barChartView.scaleXEnabled = false
            barChartView.scaleYEnabled = false
            barChartView.pinchZoomEnabled = false
            barChartView.delegate = self
        }
        
        barChartView.layer.borderColor = UIColor.black.cgColor
        barChartView.layer.borderWidth = 1
    }

    /// Called when a value from an axis is formatted before being drawn.
    /// - Parameter value: the value that is currently being drawn
    /// - Parameter axis: the axis that the value belongs to
    /// - Returns: The customized label that is drawn on the x-axis.
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value) + 1)"
    }
    
    /// Called when a value has been selected inside the chart.
    /// - parameter entry: The selected Entry.
    /// - parameter highlight: The corresponding highlight object that contains information about the highlighted position such as dataSetIndex etc.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Selected bar at x-index \(Int(entry.x))\n\tUpdating label")
        selectedLabel.text = top5![Int(entry.x)]
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Selected \(sourceType!) page of ranking tab")
    }
}
