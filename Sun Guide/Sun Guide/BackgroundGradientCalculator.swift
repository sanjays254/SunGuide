//
//  BackgroundGradientCalculator.swift
//  Sun Guide
//
//  Created by Sanjay Reck Mode on 2023-03-18.
//

import Foundation
import SwiftUI

extension ContentView {
    
    final class BackgroundGradientCalculator: ObservableObject {
        var sunsetTime: String? = nil
        var sunriseTime: String? = nil

        
        func setSunsetTime(sunsetTime: String) {
            self.sunsetTime = sunsetTime
        }
        
        func setSunriseTime(sunriseTime: String) {
            self.sunriseTime = sunriseTime
        }

        
        @Published var topColor: Color =  .yellow
        @Published var bottomColor: Color =  .red
        
        func calculate() {
            let now = Date()
            let dateFomatter = ISO8601DateFormatter()
            
            if let sunsetTime = sunsetTime,
               let sunriseTime = sunriseTime,
               let sunset = dateFomatter.date(from: sunsetTime),
               let sunrise = dateFomatter.date(from: sunriseTime) {
                
                // if Date() is > 2 hours before sunrise, start = darkPurple, end = black
                if (now.timeIntervalSince1970 < sunrise.timeIntervalSince1970 - (2*60*60) ) {
                    topColor = Color(red: 0.2, green: 0, blue: 1)
                    bottomColor = .black
                }
                
                // if Date() is < 1 hours before sunrise, start = red, end = black
                if (now.timeIntervalSince1970 < sunrise.timeIntervalSince1970 - (1*60*60)) {
                    topColor = .red
                    bottomColor = .black
                }
                
                // if Date() is > 1 after before sunrise, start = yellow, end = orange
                if (now.timeIntervalSince1970 > sunrise.timeIntervalSince1970 - (1*60*60)) {
                    topColor = .yellow
                    bottomColor = .red
                }
                
                // if Date() is > 1 hours after sunrise, start = blue, end = yellow
                if (now.timeIntervalSince1970 > sunrise.timeIntervalSince1970 + (1*60*60)) {
                    topColor = .blue
                    bottomColor = .pink
                }
                
                // if Date() is > 3 hours after sunrise, start = blue, end = yellow
                if (now.timeIntervalSince1970 > sunrise.timeIntervalSince1970 + (3*60*60)) {
                    topColor = .blue
                    bottomColor = .yellow
                }
                
                // if Date() is > 3 hours after sunrise, start = blue, end = yellow
                if (now.timeIntervalSince1970 > sunrise.timeIntervalSince1970 + (4*60*60)) {
                    topColor = .blue
                    bottomColor = .blue
                }
                
                // reverse
                
                // if Date() is > 4 hours before sunset, start = blue, end = blue
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 - (4*60*60)) {
                    topColor = .blue
                    bottomColor = .blue
                }
                
                
                // if Date() is < 3 hours before sunset, start = blue, end = yellow
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 - (3*60*60)) {
                    topColor = .blue
                    bottomColor = .yellow
                }
                
                // if Date() is < 2 hours before sunset, start = yellow, end = orange
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 - (2*60*60)) {
                    topColor = .blue
                    bottomColor = .pink
                }
                
                // if Date() is < 1 hours before sunrise, start = red, end = yellow
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 - (1*60*60)) {
                    topColor = .yellow
                    bottomColor = .red
                }
                
                // if Date() is > 1 hours after sunrise, start = black, end = red
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 + (1*60*60)) {
                    topColor = .red
                    bottomColor = .black
                }
                
                // if Date() is > 2 hours after sunrise, start = darkPurple, end = black
                if (now.timeIntervalSince1970 > sunset.timeIntervalSince1970 + (2*60*60)) {
                    topColor = Color(red: 0.2, green: 0, blue: 1)
                    bottomColor = .black
                }

            }
        }
        





    }
}
