//
//  HistoryViewController.swift
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit
import Charts

/// View that shows line chart of posts/comments cumulative score history for Reddit account
class HistoryViewController: UIViewController, IAxisValueFormatter {
    
    /// featured iOS Charts line chart
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLineChart()
    }
    
    /// set bar chart properties and load data
    func setUpLineChart() {
        // set up chart data
        let lineChartData = LineChartData()
        if let comments = setUpCommentsData(), comments.entryCount > 0 {
            lineChartData.addDataSet(comments)
        }
        if let posts = setUpPostsData(), posts.entryCount > 0 {
            lineChartData.addDataSet(posts)
        }
        lineChartView.data = lineChartData.dataSetCount > 0 ? lineChartData : nil

        // set up chart appearance
        lineChartView.noDataText = "This user account has no data for this chart."
        lineChartView.chartDescription = nil
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.labelRotationAngle = 90
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.data?.setDrawValues(false)
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = true
        lineChartView.legend.verticalAlignment = .bottom
        lineChartView.xAxis.valueFormatter = self
        lineChartView.layer.borderColor = UIColor.gray.cgColor
        lineChartView.layer.borderWidth = 1.0
    }
    
    /// parse comments from SharedData into a data series to plot
    /// - Returns: LineChartDataSet for the comments series
    func setUpCommentsData() -> LineChartDataSet? {
        guard let comments = SharedData.shared.getComments() else {
            return nil
        }
        var entries = [ChartDataEntry]()
        let count = comments.count
        var total = 0
        for i in 1...count {
            total = total + comments[count - i].score
            entries.append(ChartDataEntry(x: Double(comments[count - i].unixTime), y: Double(total)))
        }
        
        let lineChartDataSet = LineChartDataSet(values: entries, label: "Comments")
        lineChartDataSet.circleRadius = 6.0
        lineChartDataSet.lineWidth = 3.0
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.setColor(UIColor.lightGray)
        if lineChartDataSet.entryCount > 1 {
            lineChartDataSet.setCircleColor(UIColor.clear)
        } else {
            lineChartDataSet.setCircleColor(UIColor.lightGray)
        }
        return lineChartDataSet
    }
    
    /// parse posts from SharedData into a data series to plot
    /// - Returns: LineChartDataSet for the posts series
    func setUpPostsData() -> LineChartDataSet? {
        guard let submissions = SharedData.shared.getSubmissions() else {
            return nil
        }
        var entries = [ChartDataEntry]()
        let count = submissions.count
        var total = 0
        for i in 1...count {
            total = total + submissions[count - i].score
            entries.append(ChartDataEntry(x: Double(submissions[count - i].unixTime), y: Double(total)))
        }
        
        let lineChartDataSet = LineChartDataSet(values: entries, label: "Posts")
        lineChartDataSet.circleRadius = 6.0
        lineChartDataSet.lineWidth = 3.0
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.setColor(UIColor.black)
        if lineChartDataSet.entryCount > 1 {
            lineChartDataSet.setCircleColor(UIColor.clear)
        } else {
            lineChartDataSet.setCircleColor(UIColor.black)
        }
        lineChartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeInBack)
        return lineChartDataSet
    }
    
    /// Called when a value from an axis is formatted before being drawn.
    /// - Parameter value: the value that is currently being drawn
    /// - Parameter axis: the axis that the value belongs to
    /// - Returns: The customized label that is drawn on the x-axis.
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let rounded = round(value/1000000.0)
        return "\(rounded/1000.0) bn"
    }
    
    /// Used for unwinding segue from explanation view
    @IBAction func finishExplanation(from segue: UIStoryboardSegue) {
        // Do nothing
    }

}

