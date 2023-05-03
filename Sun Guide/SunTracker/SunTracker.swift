//
//  WidgetTimelineProvider.swift
//  SunTracker
//
//  Created by Sanjay Reck Mode on 2022-10-16.
//

import Foundation
import WidgetKit

struct WidgetTimelineProvider: TimelineProvider {
    var network = Network()
    
    let numberOfSecondsInOneDay: TimeInterval = 86400
    
    func calculateSunPosition(date: Date) -> Int {
        var currentPositionDegrees: Int
        if let midnight = midnightDate() {
            let secondsPassedSinceMidnight = date.timeIntervalSince(midnight)
            currentPositionDegrees = Int(secondsPassedSinceMidnight.interpolated(from: 0...numberOfSecondsInOneDay, to: -180...180))
        } else {
            currentPositionDegrees = 0
        }
        
        return currentPositionDegrees
    }
    
    let dateFormatter = ISO8601DateFormatter()
    
    
    func midnightDate() -> Date? {
        // this has been copied from Network. Should make a shared function for getting the currentSunPosition
        guard let date = self.dateFormatter.date(from: Date().ISO8601Format()) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        if let timeZone = TimeZone.current.abbreviation() {
            self.dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: "\(year)-\(month)-\(day) 00:00:00")
    }
    
    func placeholder(in context: Context) -> SunlightTimelineEntry {
        SunlightTimelineEntry(date: Date(), currentSunPosition: 45, sunriseDegrees: 0, sunsetDegrees: 0.5)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SunlightTimelineEntry) -> ()) {
        // Use userDefaults for snapshot, even though it might not be up to date
        // Fetching from the network is too slow for a snapshot
        if let userDefaults = UserDefaults(suiteName: "group.ShahLabs.WidgetTests"),
           let sunsetDegrees = userDefaults.object(forKey: "sunsetDegrees") as? CGFloat,
           let sunriseDegrees = userDefaults.object(forKey: "sunriseDegrees") as? CGFloat {
            
            let currentPositionDegrees = calculateSunPosition(date: Date())
            
            let entry = SunlightTimelineEntry(date: Date(), currentSunPosition: currentPositionDegrees, sunriseDegrees: sunriseDegrees, sunsetDegrees: sunsetDegrees)
            completion(entry)
            
        }
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SunlightTimelineEntry>) -> ()) {
        // fetch from network instead of using UserDefaults

        if let userDefaults = UserDefaults(suiteName: "group.ShahLabs.WidgetTests"),
           let sunsetDegrees = userDefaults.object(forKey: "sunsetDegrees") as? CGFloat,
           let sunriseDegrees = userDefaults.object(forKey: "sunriseDegrees") as? CGFloat {
        
//        network.getTimes { sunriseDegrees, sunsetDegrees in
            if let midnight = midnightDate() {
                
                // we should have an entry every 30 mins in a timeline.
                let updatesInADay = 48
                var entries: [SunlightTimelineEntry] = []
                
                let secondsInThirtyMins: TimeInterval = TimeInterval(1800)
                for i in 0 ... updatesInADay {
                    let entryDate = Date().addingTimeInterval(secondsInThirtyMins * TimeInterval(i))
                    
                    let currentPositionDegrees = calculateSunPosition(date: entryDate)
                    
                    let entry = SunlightTimelineEntry(date: entryDate, currentSunPosition: currentPositionDegrees, sunriseDegrees: sunriseDegrees, sunsetDegrees: sunsetDegrees)
                    
                    entries.append(entry)
                }
                
                // timeline is updated at midnight to fetch new day's sunrise and sunset times
                if let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: midnight) {
                    
                    let timeline = Timeline(
                        entries: entries,
                        policy: .after(nextUpdateDate)
                    )
                    
                    completion(timeline)
                }
                
            }
        }
    }
}
