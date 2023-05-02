//
//  SunlightLeftCalculator.swift
//  Sun Guide
//
//  Created by Sanjay Reck Mode on 2023-03-18.
//

import Foundation

extension ContentView {
    
    final class SunlightLeftCalculator: ObservableObject {
        var sunsetTime: String? = nil
        var sunriseTime: String? = nil

        
        func setSunsetTime(sunsetTime: String) {
            self.sunsetTime = sunsetTime
        }
        
        func setSunriseTime(sunriseTime: String) {
            self.sunriseTime = sunriseTime
        }

        
        @Published var countdown: String? =  nil
        
        func updateCountdown() {
            let now = Date()
            let dateFomatter = ISO8601DateFormatter()
            
            if let sunsetTime = sunsetTime,
               let sunriseTime = sunriseTime,
               let sunset = dateFomatter.date(from: sunsetTime),
               let sunrise = dateFomatter.date(from: sunriseTime) {
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 ) {
                    self.countdown = "Sun has already set"
                    return
                }
                

                
                let diff = sunset.timeIntervalSince1970 - now.timeIntervalSince1970
                
                let date = Date(timeIntervalSince1970: diff)
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(identifier: "UTC")!
                
                let hours = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let seconds = calendar.component(.second, from: date)
                
                if (now.timeIntervalSince1970 < sunrise.timeIntervalSince1970 ) {
                    self.countdown = "A full day of sun ahead of you 😌"
                    return
                }
                
                
                let countdownString = String(format: "%dh %02dm %02ds", hours, minutes, seconds)
                self.countdown = countdownString
            }

            
        }
    }
}
