//
//  StepChartView.swift
//  DailyDrops
//
//  Created by 차소민 on 3/27/24.
//

import Foundation
import DGCharts

final class StepChartView: BarChartView {
//    let value: [Double]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setDataCount(value, range: UInt32(10000))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataCount(_ value: [Double], range: UInt32) {
        let yVals = (0..<value.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(value[i]))
        }
        
        var set1: BarChartDataSet! = nil
        if let set = self.data?.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            self.data?.notifyDataChanged()
            self.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals)
            set1.colors = [.systemTeal]
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.barWidth = 0.9
            
            self.data = data
            self.doubleTapToZoomEnabled = false
            self.leftAxis.enabled = false
            self.legend.enabled = false
            self.leftAxis.axisMinimum = 0
            self.rightAxis.axisMinimum = 0
            self.scaleYEnabled = false
            self.scaleXEnabled = false
            
            let marker = ChartMarker(frame: CGRect(x: 0, y: 0, width: 50, height: 24))
            self.marker = marker
        }
    }
}
