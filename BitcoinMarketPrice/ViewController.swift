//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet private weak var marketPriceCardView: UIView!
    
    @IBOutlet private weak var lastMarketPriceLabel: UILabel!
    @IBOutlet private weak var lastMarketPriceDayLabel: UILabel!
    @IBOutlet private weak var lastMarketPriceDateLabel: UILabel!
    
    @IBOutlet private weak var beforeTheLastMarketPriceLabel: UILabel!
    @IBOutlet private weak var beforeTheLastMarketPriceDayLabel: UILabel!
    @IBOutlet private weak var beforeTheLastMarketPriceDateLabel: UILabel!
    
    @IBOutlet private weak var compareMarketPriceIcon: UIImageView!
    
    @IBOutlet private weak var showHistoryButton: UIButton!
    
    @IBOutlet private weak var lineChartView: LineChartView!
    
//    private var chartDescription = ""
//    private var values: [Value] = []
//    private let blockchainClient = BlockchainClient()
    
    private lazy var viewModel: MainViewModel = {
        return MainViewModel(timespan: .lastTwoDays)
    }()
    
    lazy var valueRangeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewModel()
    }
    
    private func setupInformation() {
        lastMarketPriceLabel.text = viewModel.lastMarketPrice
        lastMarketPriceDayLabel.text = viewModel.lastMarketPriceDay
        lastMarketPriceDateLabel.text = viewModel.lastMarketPriceDate
        
        
        beforeTheLastMarketPriceLabel.text = viewModel.beforeTheLastMarketPrice
        beforeTheLastMarketPriceDayLabel.text = viewModel.beforeTheLastMarketPriceDay
        beforeTheLastMarketPriceDateLabel.text = viewModel.beforeTheLastMarketPriceDate
        
        compareMarketPriceIcon.image = viewModel.comparativeMarketPriceImage
    }

    private func setupViewModel() {
        viewModel.onInformationLoaded = { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupInformation()
            }
        }
    }
    
    /*
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        lineChartView.delegate = self
        
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
 
 */
    
    @IBAction func showHistory(_ sender: UIButton) {
        guard let marketPriceHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {return}
        DispatchQueue.main.async {
            self.present(marketPriceHistoryViewController, animated: true)
        }
    }
    
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.timeZone = TimeZone(identifier: "GMT-3")
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: value))
    }
}


extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        lineChartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                            axis: lineChartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                            duration: 1)
    }
}
