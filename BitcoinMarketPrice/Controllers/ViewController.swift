//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet private weak var lastMarketPriceLabel: UILabel!
    @IBOutlet private weak var lastMarketPriceDayLabel: UILabel!
    @IBOutlet private weak var lastMarketPriceDateLabel: UILabel!
    
    @IBOutlet private weak var beforeTheLastMarketPriceLabel: UILabel!
    @IBOutlet private weak var beforeTheLastMarketPriceDayLabel: UILabel!
    @IBOutlet private weak var beforeTheLastMarketPriceDateLabel: UILabel!
    
    @IBOutlet private weak var compareMarketPriceIcon: UIImageView!
    @IBOutlet private weak var showHistoryButton: UIButton!
    @IBOutlet private weak var lineChartView: LineChartView!
    
    // MARK: - Properties
    private lazy var viewModel: MarketPriceViewModel = {
        return MarketPriceViewModel(timespan: .lastTwoDays)
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
    }
    
    // MARK: - Methods
    private func setupView() {
        lastMarketPriceLabel.text = viewModel.lastMarketPrice
        lastMarketPriceDayLabel.text = viewModel.lastMarketPriceDay
        lastMarketPriceDateLabel.text = viewModel.lastMarketPriceDate
        
        beforeTheLastMarketPriceLabel.text = viewModel.beforeTheLastMarketPrice
        beforeTheLastMarketPriceDayLabel.text = viewModel.beforeTheLastMarketPriceDay
        beforeTheLastMarketPriceDateLabel.text = viewModel.beforeTheLastMarketPriceDate
        
        compareMarketPriceIcon.image = viewModel.comparativeMarketPriceImage
        
        guard let marketPrice = viewModel.marketPrice else  { return }
        lineChartView.setupLineChartView(with: marketPrice)
        lineChartView.delegate = self
    }

    private func setupViewModel() {
        viewModel.onInformationLoaded = { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupView()
            }
        }
    }

    // MARK: - Actions
    @IBAction func showHistory(_ sender: UIButton) {
        guard let marketPriceHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {return}
        DispatchQueue.main.async {
            self.present(marketPriceHistoryViewController, animated: true)
        }
    }
    
}

// MARK: - Extension ChartViewDelegate
extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        lineChartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                            axis: lineChartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                            duration: 1)
    }
}





