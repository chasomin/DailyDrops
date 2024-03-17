//
//  WeekStepView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import Foundation
import SnapKit
import DGCharts

final class WeekStepView: BaseView {
    let chartView = BarChartView()
    var steps: [Double]
    
    init(steps: [Double], frame: CGRect) {
        self.steps = steps
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(chartView)

    }
    
    override func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

    }
    
    override func configureView() {
        setDataCount(steps.count, range: UInt32(10000)) //test
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let data = steps
            return BarChartDataEntry(x: Double(i), y: Double(data[i]))
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
            chartView.xAxis.enabled = false
            chartView.leftAxis.enabled = false
            chartView.rightAxis.enabled = false
            chartView.legend.enabled = false
        }
    }
}
