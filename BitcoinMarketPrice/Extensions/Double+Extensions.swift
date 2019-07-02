//
//  Double+Extensions.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

extension Double {
    
    func usdFromDouble() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        guard let priceString = currencyFormatter.string(from: NSNumber(value: self)) else {
            return "--"
        }
        return priceString
    }
    
}


