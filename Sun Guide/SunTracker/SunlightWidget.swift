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
        WidgetEntryView(entry: SunlightTimelineEntry(date: Date(), sunsetTime: "19:00", sunriseTime: "07:00", currentSunPosition: CGFloat(90), sunriseDegrees: CGFloat(0.25), sunsetDegrees: CGFloat(0.8)))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}


@available(iOSApplicationExtension 16.0, *)
struct WidgetEntryView : View {
    var entry: WidgetTimelineProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    let dateFormatter = ISO8601DateFormatter()

    
    var body: some View {
        
        // Day light bar
        
        // 0 = 6am
        // 0.25 = 12pm
        // 0.5 = 6pm
        // 0.75 = 12am
        
        
        // dayLengthInDegrees = ((entry.sunsetDegrees - entry.sunriseDegrees) / 1) * 360
        
        
        // Sun location
        
        // 0 = midday or 12
        // 90 = 6pm or 18
        // 180 = 24
        // 270 = 6
        
        // 00:00 = -180
        // 06:00 = -90
        // 12:00 = 0
        // 18:00 = 90
        
        
        // currentSunPositionDegrees = entry.currentSunPosition
        
        
        switch widgetFamily {
        case .accessoryCircular:
            

            ZStack {
                Circle()

                    .stroke(Color(.systemGray6).opacity(0.25), lineWidth: 5)
                Circle()
                    .trim(from: entry.sunriseDegrees, to: entry.sunsetDegrees)
                    .stroke(Color(.systemGray2).opacity(0.75), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(90))
//                Circle()
//                    .trim(from: entry.currentSunPosition, to: entry.currentSunPosition + 0.05)
//                    .stroke(Color(.systemGray2).opacity(1), style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                    .rotationEffect(.degrees(-180))



                Circle()
                .frame(width: 10, height: 8)
                .background(Color(.systemGray2).opacity(0))
                .offset(y: -24)

                .rotationEffect(Angle.degrees(entry.currentSunPosition))

                    Image(systemName: "sun.max")
                        .font(.system(size: 22))

                    // if Date() is past sunriseTime, show sunsetTime
//                    Text(entry.sunriseTime)
//                        .font(.system(size: 10))



            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))


        default:
            ZStack {
                Circle()
                    
                    .stroke(Color(.systemGray6).opacity(0.25), lineWidth: 5)
                Circle()
                    .trim(from: entry.sunriseDegrees, to: entry.sunsetDegrees)
                    .stroke(Color(.systemGray2).opacity(0.75), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(90))
//                Circle()
//                    .trim(from: entry.currentSunPosition, to: entry.currentSunPosition + 0.05)
//                    .stroke(Color(.systemGray2).opacity(1), style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                    .rotationEffect(.degrees(-180))
                
                
                
                Circle()
                .frame(width: 10, height: 8)
                .background(Color(.systemGray2).opacity(0))
                .offset(y: -24)
                
                .rotationEffect(Angle.degrees(entry.currentSunPosition))
                
                    Image(systemName: "sun.max")
                        .font(.system(size: 22))
                    
                    // if Date() is past sunriseTime, show sunsetTime
//                    Text(entry.sunriseTime)
//                        .font(.system(size: 10))
                

                
            }
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
