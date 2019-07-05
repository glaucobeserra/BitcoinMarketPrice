//
//  MainViewModel.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 04/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    var onInformationLoaded: ((MarketPrice?) -> Void)?
    var onInformationFailed: ((String?) -> Void)?
    
    private lazy var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    private var marketPrice: MarketPrice? {
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
    
    // last values
    
    private var lastValue: Value? {
        let lastValue = marketPrice?.values.last
        return lastValue
    }
    
    var lastMarketPrice: String {
        guard let value = lastValue else { return "--" }
        let valueUSD = NSNumber(value: value.usd)
        guard let formattedValue = valueFormatter.string(from: valueUSD) else { return "--" }
        return formattedValue
    }
    
    var lastMarketPriceDate: String {
        guard let value = lastValue else { return "--" }
        let formattedDate = dateFormatter.string(from: value.date)
        return formattedDate
    }
    
    var lastMarketPriceDay: String {
        return String(lastMarketPriceDate.prefix(2))
    }
    
    // before the last values
    
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
    
    var beforeTheLastMarketPrice: String {
        guard let value = beforeTheLastValue else { return "--" }
        let valueUSD = NSNumber(value: value.usd)
        guard let formattedValue = valueFormatter.string(from: valueUSD) else { return "--" }
        return formattedValue
    }
    
    var beforeTheLastMarketPriceDate: String {
        guard let value = beforeTheLastValue else { return "--" }
        let formattedDate = dateFormatter.string(from: value.date)
        return formattedDate
    }
    
    var beforeTheLastMarketPriceDay: String {
        return String(beforeTheLastMarketPriceDate.prefix(2))
    }
    
    var comparativeMarketPriceImage: UIImage? {
        guard let lastValue = lastValue,
            let beforeTheLastValue = beforeTheLastValue else { return PriceComparativeImage.indifferent.image }
        
        if lastValue.usd > beforeTheLastValue.usd {
            return PriceComparativeImage.increase.image
        } else if lastValue.usd < beforeTheLastValue.usd {
            return PriceComparativeImage.decrease.image
        }
        
        return PriceComparativeImage.indifferent.image
    }
    
    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { [weak self] result in
            switch result {
            case .success(let marketPrice):
                
                guard let marketPrice = marketPrice else { return }
                self?.marketPrice = marketPrice
//                let values = marketPrice.values
//
//                self.values = values
//                self.chartDescription = marketPrice.description
//                self.refreshValues(with: values)
//                self.updateGraph()
                
            case .failure(let error):
                self?.onInformationFailed?(error.localizedDescription)
            }
        }
    }
    
}

enum PriceComparativeImage {
    case increase
    case decrease
    case indifferent
}

extension PriceComparativeImage {
    var image: UIImage {
        switch self {
        case .increase:
            return UIImage(named: "increaseIcon")!
        case .decrease:
            return UIImage(named: "decreaseIcon")!
        default:
            return UIImage(named: "equalIcon")!
        }
    }
}
