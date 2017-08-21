//
//  CompositionViewController
//  Karma Tracker for Reddit
//
//  Created by Alan Cham on 8/10/17.
//  Copyright © 2017 Alan Cham. All rights reserved.
//

import UIKit
import Charts

class CompositionViewController: UIViewController, IValueFormatter {

    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBarChart()
    }
    
    func setUpBarChart() {
        pieChartView.chartDescription = nil
        
        let commentsDataEntry = PieChartDataEntry(value: Double(SharedData.shared.numComments), label: "Comments")
        let postsDataEntry = PieChartDataEntry(value: Double(SharedData.shared.numSubmitted), label: "Posts")
        let pieChartDataSet = PieChartDataSet(values: [postsDataEntry, commentsDataEntry], label: "Total Contribution")
        pieChartDataSet.colors = [UIColor.black, UIColor.lightGray]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueFormatter(self)
        
        pieChartView.noDataText = "This user account has no data"
        pieChartView.layer.borderWidth = 1
        pieChartView.layer.borderColor = UIColor.gray.cgColor
        if SharedData.shared.numComments > 0 || SharedData.shared.numSubmitted > 0 {
            pieChartView.data = pieChartData
        }
        pieChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInCirc)
    }

    /// Called when a value (from labels inside the chart) is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The formatted label ready for being drawn
    ///
    /// - parameter value:           The value to be formatted
    ///
    /// - parameter axis:            The entry the value belongs to - in e.g. BarChart, this is of class BarEntry
    ///
    /// - parameter dataSetIndex:    The index of the DataSet the entry in focus belongs to
    ///
    /// - parameter viewPortHandler: provides information about the current chart state (scale, translation, ...)
    ///
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }

}

