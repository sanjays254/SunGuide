//
//  WidgetTimelineProvider.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-10-16.
//

import Foundation
import WidgetKit

struct WidgetTimelineProvider: TimelineProvider {



    
    func placeholder(in context: Context) -> SunlightTimelineEntry {
        SunlightTimelineEntry(date: Date(), sunsetTime: "Placeholder time", sunriseTime: "Sunrise am", currentSunPosition: 45, sunriseDegrees: 0, sunsetDegrees: 0.5)
    }

    func getSnapshot(in context: Context, completion: @escaping (SunlightTimelineEntry) -> ()) {
        let sunsetTime = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunsetTime")
        let sunriseTime = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunriseTime")

        let sunsetDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunsetDegrees")
        let sunriseDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunriseDegrees")
        let currentPositionDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "currentPositionDegrees")
        
        if let sunsetTime = sunsetTime as? String, let sunriseTime = sunriseTime as? String, let sunsetDegrees = sunsetDegrees as? CGFloat, let sunriseDegrees = sunriseDegrees as? CGFloat, let currentPositionDegrees = currentPositionDegrees as? CGFloat {
            let entry = SunlightTimelineEntry(date: Date(), sunsetTime: sunsetTime, sunriseTime: sunriseTime, currentSunPosition: currentPositionDegrees, sunriseDegrees: sunriseDegrees, sunsetDegrees: sunsetDegrees)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SunlightTimelineEntry>) -> ()) {        
        let sunsetTime = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunsetTime")
        let sunriseTime = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunriseTime")

        let sunsetDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunsetDegrees")
        let sunriseDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "sunriseDegrees")
        let currentPositionDegrees = UserDefaults(suiteName: "group.ShahLabs.WidgetTests")!.object(forKey: "currentPositionDegrees")
        
        let date = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
        
        if let sunsetTime = sunsetTime as? String, let sunriseTime = sunriseTime as? String, let sunsetDegrees = sunsetDegrees as? CGFloat, let sunriseDegrees = sunriseDegrees as? CGFloat, let currentPositionDegrees = currentPositionDegrees as? CGFloat {
            
            let entry = SunlightTimelineEntry(date: date, sunsetTime: sunsetTime, sunriseTime: sunriseTime, currentSunPosition: currentPositionDegrees, sunriseDegrees: sunriseDegrees, sunsetDegrees: sunsetDegrees)
            
            let timeline = Timeline(
                entries:[entry],
                policy: .after(nextUpdateDate)
            )
            
            completion(timeline)
        }
        
    }
}
