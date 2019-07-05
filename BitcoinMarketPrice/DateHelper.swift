//
//  DateHelper.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 05/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

class DateHelper {
    static let shared = DateHelper()
    
    lazy var completeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
}
