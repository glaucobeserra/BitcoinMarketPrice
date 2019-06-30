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
    }

    
    private func getMarketPrice(at timespan: Timespan) {
        blockchainClient.getMarketPrice(at: timespan) { result in
            switch result {
            case .success(let marketPrice):
                guard let history = marketPrice?.values else { return }
                print(history)
            case .failure(let error):
                print(error)
            }
        }
    }

}

