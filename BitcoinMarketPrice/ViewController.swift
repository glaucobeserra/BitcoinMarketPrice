//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var marketPriceDayLabel: UILabel!
    @IBOutlet weak var marketPriceDateLabel: UILabel!
    
    private let blockchainClient = BlockchainClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMarketPrice(at: .lastDay)
    }

    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { result in
            switch result {
            case .success(let marketPrice):
                guard let history = marketPrice?.values else { return }
                guard let value = history.first else {return}
                self.refreshValues(with: value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func refreshValues(with value: Value) {
        DispatchQueue.main.async {
            
            self.marketPriceLabel.text = value.usd.usdFromDouble()
            
            let day = value.date.stringFromDate(format: "dd")
            self.marketPriceDayLabel.text = day
            print(day)
            
            let completeDate = value.date.stringFromDate()
            self.marketPriceDateLabel.text = completeDate
            print(completeDate)
        }
    }

}

