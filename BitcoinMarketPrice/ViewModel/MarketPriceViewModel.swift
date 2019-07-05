//
//  MarketPriceViewModel.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 04/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit
import Charts

class MarketPriceViewModel: NSObject {
    
    // MARK:- Stored properties
    var onInformationLoaded: ((MarketPrice?) -> Void)?
    var onInformationFailed: ((String?) -> Void)?
    
    private let numberHelper = NumberHelper.shared
    private let dateHelper = DateHelper.shared
    
    var marketPrice: MarketPrice? {
        didSet {
            onInformationLoaded?(marketPrice)
        }
    }
    
    private let blockchainClient: BlockchainClient
    private let timespan: Timespan
    
    init(client: BlockchainClient = BlockchainClient(), timespan: Timespan) {
        self.blockchainClient = client
        self.timespan = timespan
        super.init()
        
        getMarketPrice(at: self.timespan)
    }
    
    private var lastValue: Value? {
        let lastValue = marketPrice?.values.last
        return lastValue
    }
    
    private var beforeTheLastValue: Value? {
        guard let values = marketPrice?.values else {return nil}
        let count = values.count
        let index = count - 2
        let isIndexValid = values.indices.contains(index)
        if isIndexValid {
            return values[index]
        }
        return nil
        
    }
    
    func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { [weak self] result in
            switch result {
            case .success(let marketPrice):
                
                guard let marketPrice = marketPrice else { return }
                self?.marketPrice = marketPrice
            case .failure(let error):
                self?.onInformationFailed?(error.localizedDescription)
            }
        }
    }
}

// MARK: - Public properties

extension MarketPriceViewModel {
    
    // - Last market price properties
    
    var lastMarketPrice: String {
        guard let value = lastValue else { return "--" }
        let valueUSD = NSNumber(value: value.usd)
        let formatter = numberHelper.valueFormatter
        guard let formattedValue = formatter.string(from: valueUSD) else { return "--" }
        return formattedValue
    }
    
    var lastMarketPriceDay: String {
        guard let value = lastValue else { return "--" }
        let formatter = dateHelper.dayFormatter
        let formattedDate = formatter.string(from: value.date)
        return formattedDate
    }
    
    var lastMarketPriceDate: String {
        guard let value = lastValue else { return "--" }
        let formatter = dateHelper.completeDateFormatter
        let formattedDate = formatter.string(from: value.date)
        return formattedDate
    }
    
    // - Before the last market price properties
    
    var beforeTheLastMarketPrice: String {
        guard let value = beforeTheLastValue else { return "--" }
        let valueUSD = NSNumber(value: value.usd)
        let formatter = numberHelper.valueFormatter
        guard let formattedValue = formatter.string(from: valueUSD) else { return "--" }
        return formattedValue
    }
    
    var beforeTheLastMarketPriceDate: String {
        guard let value = beforeTheLastValue else { return "--" }
        let formatter = dateHelper.completeDateFormatter
        let formattedDate = formatter.string(from: value.date)
        return formattedDate
    }
    
    var beforeTheLastMarketPriceDay: String {
        guard let value = beforeTheLastValue else { return "--" }
        let formatter = dateHelper.dayFormatter
        let formattedDate = formatter.string(from: value.date)
        return formattedDate
    }
    
    var comparativeMarketPriceImage: UIImage? {
        guard let lastValue = lastValue,
            let beforeTheLastValue = beforeTheLastValue else { return ComparativePriceImage.indifferent.image }
        
        if lastValue.usd > beforeTheLastValue.usd {
            return ComparativePriceImage.increase.image
        } else if lastValue.usd < beforeTheLastValue.usd {
            return ComparativePriceImage.decrease.image
        }
        
        return ComparativePriceImage.indifferent.image
    }
}
