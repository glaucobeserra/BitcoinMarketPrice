//
//  LineChartView+Extension.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 05/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation
import Charts

extension LineChartView {

    func setupLineChartView(with marketPrice: MarketPrice) {
        
        var lineChartEntry  = [ChartDataEntry]()
        let numberHelper = NumberHelper.shared
        for value in marketPrice.values {
            let date = value.date.timeIntervalSinceReferenceDate
            let value = ChartDataEntry(x: date, y: value.usd)
            lineChartEntry.append(value)
        }
        
        let leftAxis = self.leftAxis
        let rangeFormatter = numberHelper.valueRangeFormatter
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: rangeFormatter)
        self.backgroundColor = .white
        
        let xAxis = self.xAxis
        
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.granularity = 86400.0
        xAxis.granularityEnabled = true
        xAxis.drawGridLinesEnabled = false
        
        self.rightAxis.enabled = false
        
        let line = LineChartDataSet(entries: lineChartEntry, label: marketPrice.name)
        let lineColor = UIColor(red: 3/255, green: 155/255, blue: 211/255, alpha: 1)
        line.colors = [lineColor]
        line.circleRadius = 1.5
        line.circleColors = [.red]
        line.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line)
        let valueFormatter = numberHelper.valueFormatter
        data.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
        
        self.data = data
        self.chartDescription?.text = marketPrice.description
    }
}
