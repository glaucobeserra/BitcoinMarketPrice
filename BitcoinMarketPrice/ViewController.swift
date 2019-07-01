//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let blockchainClient = BlockchainClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMarketPrice(at: .lastDay)
    }

    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { result in
            switch result {
            case .success(let marketPrice):
                guard let history = marketPrice?.values else { return }
                guard let value = history.first else {return}
                let date = value.date
                let valueUSD = value.usd
                
                print(date.stringFromDate())
                print(valueUSD.usdFromDouble())
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

