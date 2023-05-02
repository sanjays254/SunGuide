//
//  QuoteWidget.swift
//  QuoteWidget
//
//  Created by Sanjay Reck Mode on 2022-07-30.
//

import WidgetKit
import SwiftUI
import Intents

@available(iOSApplicationExtension 16.0, *)
@main
struct SunlightWidget: Widget {
    let kind: String = "SunlightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetTimelineProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sun Tracker")
        .description("More options to come in the future!")
                #if os(watchOS)
                    .supportedFamilies([.accessoryCircular])
                #else
                    .supportedFamilies([.accessoryCircular])
                #endif
    }
}


@available(iOSApplicationExtension 16.0, *)
struct SunlightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SunlightTimelineEntry(date: Date(), currentSunPosition: 45, sunriseDegrees: CGFloat(0.25), sunsetDegrees: CGFloat(0.8)))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}


@available(iOSApplicationExtension 16.0, *)
struct WidgetEntryView : View {
    var entry: WidgetTimelineProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    let gaugeLineWidth: CGFloat = 5
    
    // Gauge Degrees with Rotation Effect 90
    //
    //       0.50
    //
    // 0.25       0.75
    //
    //        0
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            ZStack {
                Circle()
                    .stroke(Color(.systemGray6).opacity(0.25), lineWidth: gaugeLineWidth)
                Circle()
                    .trim(from: entry.sunriseDegrees, to: entry.sunsetDegrees)
                    .stroke(Color(.systemGray2).opacity(0.75), style: StrokeStyle(lineWidth: gaugeLineWidth, lineCap: .round))
                    .rotationEffect(.degrees(90))
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 10))
                    .offset(y: -28)
                    .rotationEffect(Angle.degrees(Double(entry.currentSunPosition)))
                
                Image(systemName: "camera.macro")
                    .font(.system(size: 15))
                    .offset(y: -3)

                
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 10))
                    .offset(y: 9)

            }
            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
        default:
            Image(systemName: "sun.max")
                .font(.system(size: 22))
        }
    }
}
