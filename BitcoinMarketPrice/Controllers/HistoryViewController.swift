//
//  HistoryViewController.swift
//  BitcoinMarketPrice
//
//  Created by Glauco Dantas Beserra on 01/07/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController {
    
    @IBOutlet private weak var lineChartView: LineChartView!
    
    private lazy var viewModel: MainViewModel = {
        return MainViewModel(timespan: .lastWeek)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
    }
    
    private func setupView() {
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
    
    // MARK:- Actions
    @IBAction func closeHistory(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func getLastWeek(_ sender: UIButton) {
        viewModel.getMarketPrice(at: .lastWeek)
        
    }
    @IBAction func getLastMonth(_ sender: UIButton) {
        viewModel.getMarketPrice(at: .lastMonth)
    }
    
    @IBAction func getSixtyDays(_ sender: UIButton) {
        viewModel.getMarketPrice(at: .sixtyDays)
    }
    @IBAction func getNinetyDays(_ sender: UIButton) {
        viewModel.getMarketPrice(at: .ninetyDays)
    }
    
}

// MARK: - Extension ChartViewDelegate
extension HistoryViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        lineChartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                           axis: lineChartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                           duration: 1)
    }
}
