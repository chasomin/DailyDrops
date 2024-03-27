//
//  MonthStepView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation
import SnapKit
import DGCharts

final class MonthStepView: BaseView {
    let chartView = StepChartView()
    
    override func configureHierarchy() {
        addSubview(chartView)
    }
    
    override func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
