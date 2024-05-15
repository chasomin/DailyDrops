//
//  WidgetUpdate.swift
//  DailyDrops
//
//  Created by 차소민 on 5/15/24.
//

import Foundation
import WidgetKit

protocol WidgetUpdate { }

extension WidgetUpdate {
    func widgetUpdate() {
        WidgetCenter.shared.reloadTimelines(ofKind: Constants.widgetID)
    }
}
