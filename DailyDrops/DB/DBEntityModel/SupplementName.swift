//
//  SupplementName.swift
//  DailyDrops
//
//  Created by 차소민 on 3/16/24.
//

import Foundation

struct SupplementName: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let supplementID: UUID
}
