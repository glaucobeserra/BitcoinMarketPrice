//
//  Date+Extensions.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

extension Date {
    func stringFromDate(format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
