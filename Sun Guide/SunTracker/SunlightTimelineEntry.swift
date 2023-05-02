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
    let currentSunPosition: Int
    let sunriseDegrees: CGFloat
    let sunsetDegrees: CGFloat
}
