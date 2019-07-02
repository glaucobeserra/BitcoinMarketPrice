//
//  MainViewModel.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 01/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation
import Charts

class MainViewModel {
    
    private var values: [Value] = []
    private var chartDescription = ""
    private var marketPrice: MarketPrice?
    private let blockchainClient = BlockchainClient()
    
    private lazy var valueRangeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    private lazy var valueFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        return currencyFormatter
    }()
    
//    var lastMarketPriceInformation: Value {
//
//    }
//
//    var beforeLastMarketPriceInformation: Value {
//
//    }
}

//MARK: - Auxiliary methods

extension MainViewModel {
    
    func updateGraph(with values: [Value]) -> LineChartView {
        let lineChartView = LineChartView()
        
        var leftAxis = lineChartView.leftAxis
        leftAxis = configureLeftAxis(with: leftAxis)
        
        var xAxis = lineChartView.xAxis
        xAxis = configureXAxis(with: xAxis)
        
        let chartDataEntry = configureChartDataEntry(with: values)
        let line = configureLine(with: chartDataEntry)
        let data = configureLineChartData(with: line)
        
        lineChartView.data = data
//        lineChartView.delegate = self
        lineChartView.backgroundColor = .white
        lineChartView.rightAxis.enabled = false
        lineChartView.chartDescription?.text = chartDescription
        return lineChartView
    }
    
    private func configureLeftAxis(with leftAxis: YAxis) -> YAxis {
        //        let leftAxis = lineChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valueRangeFormatter)
        return leftAxis
    }
    
    private func configureXAxis(with xAxis: XAxis) -> XAxis {
        //        let xAxis = lineChartView.xAxis
        xAxis.spaceMin = 10
        xAxis.granularity = 86400.0
        xAxis.granularityEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = DateValueFormatter()
        return xAxis
    }
    
    private func configureChartDataEntry(with: [Value]) -> [ChartDataEntry] {
        var lineChartEntry  = [ChartDataEntry]()
        for value in values {
            let date = value.date.timeIntervalSinceReferenceDate
            let value = ChartDataEntry(x: date, y: value.usd)
            lineChartEntry.append(value)
        }
        return lineChartEntry
    }
    
    private func configureLine(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let line = LineChartDataSet(entries: entries, label: "Bitcoin Market Price (USD)")
        let blueLineColor = UIColor(red: 3/255, green: 155/255, blue: 211/255, alpha: 1)
        line.colors = [blueLineColor]
        line.circleRadius = 1.5
        line.circleColors = [.red]
        line.mode = .cubicBezier
        return line
    }
    
    private func configureLineChartData(with line: LineChartDataSet) -> LineChartData {
        let data = LineChartData()
        data.addDataSet(line)
        data.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
        return data
    }
}
