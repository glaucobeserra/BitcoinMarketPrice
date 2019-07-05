//
//  HistoryViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 01/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    lazy var valueRangeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    lazy var valueFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        return currencyFormatter
    }()
    
    private let blockchainClient = BlockchainClient()
    var chartDescription = ""
    var values: [Value] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getMarketPrice(at: .lastMonth)
    }
    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { result in
            switch result {
            case .success(let marketPrice):
                
                guard let marketPrice = marketPrice else { return }
                let values = marketPrice.values
                
                self.values = values
                self.chartDescription = marketPrice.description
//                self.refreshValues(with: values)
                self.updateGraph()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for value in values {
            let date = value.date.timeIntervalSinceReferenceDate
            let value = ChartDataEntry(x: date, y: value.usd) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valueRangeFormatter)
        lineChartView.backgroundColor = .white
        
        let xAxis = lineChartView.xAxis
        
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.granularity = 86400.0
        xAxis.labelCount = 2
        xAxis.granularityEnabled = true
        xAxis.spaceMin = 10
        xAxis.drawGridLinesEnabled = false
        
        lineChartView.rightAxis.enabled = false
        
        
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Bitcoin Market Price (USD)")
        let lineColor = UIColor(red: 3/255, green: 155/255, blue: 211/255, alpha: 1)
        line1.colors = [lineColor] //Sets the colour to blue
        line1.circleRadius = 1.5
        line1.circleColors = [.red]
        line1.mode = .cubicBezier
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        data.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
        
        lineChartView.data = data //finally - it adds the chart data to the chart and causes an update
        lineChartView.chartDescription?.text = chartDescription // Here we set the description for the graph
    }
    
    // MARK:- Actions
    @IBAction func closeHistory(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func getLastWeek(_ sender: UIButton) {
        getMarketPrice(at: .lastWeek)
    }
    @IBAction func getLastMonth(_ sender: UIButton) {
        getMarketPrice(at: .lastMonth)
    }
    
    @IBAction func getSixtyDays(_ sender: UIButton) {
        getMarketPrice(at: .sixtyDays)
    }
    @IBAction func getNinetyDays(_ sender: UIButton) {
        getMarketPrice(at: .ninetyDays)
    }
    
}
