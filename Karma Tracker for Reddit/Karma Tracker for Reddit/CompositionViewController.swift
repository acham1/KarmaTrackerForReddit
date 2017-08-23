//
//  CompositionViewController
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit
import Charts

/// View that shows pie chart of posts/comments count for Reddit account
class CompositionViewController: UIViewController, IValueFormatter {

    /// featured iOS Charts Pie Chart View
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarChart()
    }
    
    /// set bar chart properties and load data
    func setUpBarChart() {
        pieChartView.chartDescription = nil

        // set up data
        let commentsDataEntry = PieChartDataEntry(value: Double(SharedData.shared.numComments), label: "Comments")
        let postsDataEntry = PieChartDataEntry(value: Double(SharedData.shared.numSubmitted), label: "Posts")
        let pieChartDataSet = PieChartDataSet(values: [postsDataEntry, commentsDataEntry], label: "Total Contribution")
        pieChartDataSet.colors = [UIColor.black, UIColor.lightGray]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueFormatter(self)

        // set up pie chart appearance
        pieChartView.noDataText = "This user account has no data for this chart."
        pieChartView.layer.borderWidth = 1
        pieChartView.layer.borderColor = UIColor.gray.cgColor
        if SharedData.shared.numComments > 0 || SharedData.shared.numSubmitted > 0 {
            pieChartView.data = pieChartData
        }
        pieChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInCirc)
    }

    /// Called when a value (from labels inside the chart) is formatted before being drawn.
    /// - Parameter value: The value to be formatted
    /// - Parameter axis: The entry the value belongs to - in e.g. BarChart, this is of class BarEntry
    /// - Parameter dataSetIndex: The index of the DataSet the entry in focus belongs to
    /// - Parameter viewPortHandler: provides information about the current chart state (scale, translation, ...)
    /// - Returns: The formatted label ready for being drawn
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }

}

