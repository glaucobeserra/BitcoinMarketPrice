//
//  NumberHelper.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 05/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

class NumberHelper {
    static let shared = NumberHelper()
    
    lazy var valueRangeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    lazy var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }()
}
