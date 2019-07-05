//
//  DateValueFormatter.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 05/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation
import Charts

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
