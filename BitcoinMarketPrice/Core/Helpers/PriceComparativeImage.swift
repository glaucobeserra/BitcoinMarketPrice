//
//  PriceComparativeImage.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 05/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit

enum ComparativePriceImage {
    case increase
    case decrease
    case indifferent
}

extension ComparativePriceImage {
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
