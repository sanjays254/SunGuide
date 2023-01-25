//
//  SunlightTimelineEntry.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-10-16.
//

import Foundation
import WidgetKit

struct SunlightTimelineEntry: TimelineEntry {
    var date: Date
    let sunsetTime: String
    let sunriseTime: String
    let currentSunPosition: CGFloat
    let sunriseDegrees: CGFloat
    let sunsetDegrees: CGFloat
    let configuration: ConfigurationIntent
}
