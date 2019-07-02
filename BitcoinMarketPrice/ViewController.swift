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
    
    @IBOutlet weak var lastMarketPriceLabel: UILabel!
    @IBOutlet weak var lastMarketPriceDayLabel: UILabel!
    @IBOutlet weak var lastMarketPriceDateLabel: UILabel!
    
    @IBOutlet weak var beforeTheLastMarketPriceLabel: UILabel!
    @IBOutlet weak var beforeTheLastMarketPriceDayLabel: UILabel!
    @IBOutlet weak var beforeTheLastMarketPriceDateLabel: UILabel!
    
    @IBOutlet weak var compareMarketPriceIcon: UIImageView!
    
    @IBOutlet weak var showHistoryButton: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    private var viewModel = MainViewModel()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMarketPrice(at: .lastTwoDays)
    }

    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { result in
            switch result {
            case .success(let marketPrice):
                
                guard let marketPrice = marketPrice else { return }
                self.marketPrice = marketPrice
                
                self.values = marketPrice.values
                self.chartDescription = marketPrice.description
                self.refreshValues(with: self.values)
                self.updateGraph()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func refreshValues(with values: [Value]) {
        guard values.count == 2 else {return}
        guard let lastValue = values.last else {return}
        guard let beforeTheLastValue = values.first else {return}
        DispatchQueue.main.async {
            self.lastMarketPriceLabel.text = lastValue.usd.usdFromDouble()
            self.lastMarketPriceDayLabel.text = lastValue.date.stringFromDate(format: "dd")
            self.lastMarketPriceDateLabel.text = lastValue.date.stringFromDate()
            
            self.beforeTheLastMarketPriceLabel.text = beforeTheLastValue.usd.usdFromDouble()
            self.beforeTheLastMarketPriceDayLabel.text = beforeTheLastValue.date.stringFromDate(format: "dd")
            self.beforeTheLastMarketPriceDateLabel.text = beforeTheLastValue.date.stringFromDate()
            
            var compareMarketPriceImage = UIImage()
            
            if lastValue.usd > beforeTheLastValue.usd {
                compareMarketPriceImage = UIImage(named: "increaseIcon") ?? UIImage()
            } else if lastValue.usd < beforeTheLastValue.usd {
                compareMarketPriceImage = UIImage(named: "decreaseIcon") ?? UIImage()
            } else {
                compareMarketPriceImage = UIImage(named: "equalIcon") ?? UIImage()
            }
            
            self.compareMarketPriceIcon.image = compareMarketPriceImage
        }
    }
    
//    func updateGraph(){
//        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//        for value in values {
//            let date = value.date.timeIntervalSinceReferenceDate
//            let value = ChartDataEntry(x: date, y: value.usd) // here we set the X and Y status in a data chart entry
//            lineChartEntry.append(value) // here we add it to the data set
//        }
//
//        let leftAxis = lineChartView.leftAxis
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valueRangeFormatter)
//
//        let xAxis = lineChartView.xAxis
//        xAxis.spaceMin = 10
//        xAxis.granularity = 86400.0
//        xAxis.granularityEnabled = true
//        xAxis.drawGridLinesEnabled = false
//        xAxis.centerAxisLabelsEnabled = true
//        lineChartView.rightAxis.enabled = false
//        xAxis.valueFormatter = DateValueFormatter()
//
//
//        let line = LineChartDataSet(entries: lineChartEntry, label: "Bitcoin Market Price (USD)")
//        let blueLineColor = UIColor(red: 3/255, green: 155/255, blue: 211/255, alpha: 1)
//        line.colors = [lineColor]
//        line.circleRadius = 1.5
//        line.circleColors = [.red]
//        line.mode = .cubicBezier
//
//        let data = LineChartData()
//        data.addDataSet(line)
//        data.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
//
//
//        lineChartView.data = data
//        lineChartView.delegate = self
//        lineChartView.backgroundColor = .white
//        lineChartView.chartDescription?.text = chartDescription
//    }
    
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
