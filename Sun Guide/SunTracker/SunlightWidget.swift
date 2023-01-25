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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: WidgetTimelineProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sun")
        .description("More options to come in the future!")
                #if os(watchOS)
                    .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner])
                #else
                    .supportedFamilies([.accessoryCircular])
                #endif
    }
}


@available(iOSApplicationExtension 16.0, *)
struct SunlightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SunlightTimelineEntry(date: Date(), sunsetTime: "19:00", sunriseTime: "07:00", currentSunPosition: CGFloat(0.25), sunriseDegrees: CGFloat(0), sunsetDegrees: CGFloat(0.5), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}


@available(iOSApplicationExtension 16.0, *)
struct WidgetEntryView : View {
    var entry: WidgetTimelineProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    let dateFormatter = ISO8601DateFormatter()

    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            ZStack {
                Circle()
                    .stroke(Color(.systemGray6).opacity(0.25), lineWidth: 10)
                Circle()
                    .trim(from: entry.sunriseDegrees, to: entry.sunsetDegrees)
                    .stroke(Color(.systemGray2).opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                    .rotationEffect(.degrees(-180))
                Circle()
                    .trim(from: entry.currentSunPosition, to: entry.currentSunPosition + 0.05)
                    .stroke(Color(.systemGray2).opacity(1), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-180))
                VStack {
                    Image(systemName: "sun.and.horizon")
                        .font(.system(size: 20))
                    
                    // if Date() is past sunriseTime, show sunsetTime
//                    Text(entry.sunriseTime)
//                        .font(.system(size: 10))
                }

                
            }

        default:
            Spacer()
//            HStack{
//                Spacer()
//                VStack{
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Image(systemName: "sun.and.horizon")
//                                .foregroundColor(.white)
//                                .font(.system(size: 35))
//
//
//                            Text(dateFormatter.date(
//                                from:entry.sunsetTime ?? ""
//                            )?.formatted(date: .omitted, time: .shortened).lowercased() ?? "Dunno")
//
//                            .foregroundColor(.white)
//                            .font(.title)
//                        }
//                        .padding(20)
//                        Spacer()
//                        VStack(alignment: .trailing) {
//                            Image(systemName: "sun.and.horizon")
//                                .foregroundColor(.white)
//                                .font(.system(size: 35))
//
//                            Text(
//                                dateFormatter.date(
//                                    from:entry.sunsetTime ?? ""
//                                )?.formatted(date: .omitted, time: .shortened).lowercased() ?? "Dunno")
//
//                            .foregroundColor(.white)
//                            .font(.title)
//
//                        }
//                        .padding(20)
//
//                        .cornerRadius(10)
//
//                    }
//
//                }
//                Spacer()
//            }
//            .background(
//                VStack{
//                    LinearGradient(gradient: Gradient(colors: [.blue]), startPoint: .top, endPoint: .bottom)
//                        .padding(.bottom, -8)
//                    LinearGradient(gradient: Gradient(colors: [.blue, .orange, .red]), startPoint: .top, endPoint: .bottom)
//
//                }
//            )
//            .opacity(0.8)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        }
    }
}
