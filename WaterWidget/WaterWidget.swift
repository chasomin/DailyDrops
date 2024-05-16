//
//  WaterWidget.swift
//  WaterWidget
//
//  Created by 차소민 on 5/13/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WaterWidgetEntryView : View {
    var entry: Provider.Entry
    let repository = RealmRepository()

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    let waterHeight = geometry.size.height
                    / CGFloat(repository.readGoalCups(date: Date()))
                    * CGFloat(repository.readWaterByDate(date: Date()))
                    
                    Spacer()
                        .frame(height: geometry.size.height - waterHeight)
                    Rectangle()
                        .fill(.teal)
                        .frame(height: waterHeight)
                }
            }
            
            Image(.cup)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaledToFill()
                .padding(.leading, 15)
                .padding(.trailing, 10)
                .padding(.vertical, 15)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WaterWidget: Widget {
    let kind: String = "WaterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WaterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WaterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
