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

    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var marketPriceDayLabel: UILabel!
    @IBOutlet weak var marketPriceDateLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    var chartDescription = ""
    var values: [Value] = []
    private let blockchainClient = BlockchainClient()
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    lazy var newFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        return currencyFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                
                guard let lastValue = values.last else {return}
                self.refreshValues(with: lastValue)
                self.updateGraph()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func refreshValues(with value: Value) {
        DispatchQueue.main.async {
            
            self.marketPriceLabel.text = value.usd.usdFromDouble()
            
            let day = value.date.stringFromDate(format: "dd")
            self.marketPriceDayLabel.text = day
            print(day)
            
            let completeDate = value.date.stringFromDate()
            self.marketPriceDateLabel.text = completeDate
            print(completeDate)
        }
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
//        leftAxis.axisMinimum = 0
        lineChartView.backgroundColor = .white
        
        
        lineChartView.rightAxis.enabled = false
        
        //here is the for loop
        for (i, value) in values.enumerated() {
            let value = ChartDataEntry(x: Double(i), y: value.usd) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Bitcoin Market Price (USD)")
        
//        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [.blue] //Sets the colour to blue
        line1.circleRadius = 0.5
        line1.mode = .cubicBezier
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        data.setValueFormatter(DefaultValueFormatter(formatter: newFormatter))
        
        lineChartView.data = data //finally - it adds the chart data to the chart and causes an update
        lineChartView.chartDescription?.text = chartDescription // Here we set the description for the graph
    }

}

