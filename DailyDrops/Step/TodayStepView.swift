//
//  TodayStepView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation
import SnapKit
import DGCharts

class TodayStepView: BaseView {
    let chartView = BarChartView()

    override func configureHierarchy() {
        addSubview(chartView)
    }
    
    override func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    func setDataCount(_ value: [Double], range: UInt32) {
        let yVals = (0..<value.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(value[i]))
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals)
            set1.colors = [.systemTeal]
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.barWidth = 0.9
            
            chartView.data = data
            chartView.doubleTapToZoomEnabled = false
            chartView.leftAxis.enabled = false
            chartView.legend.enabled = false
        }
    }
}
