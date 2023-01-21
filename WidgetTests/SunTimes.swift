//
//  SunTimes.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-10-12.
//

import Foundation


struct SunriseSunsetAPI: Decodable {
    var results: SunTimes
}

struct SunTimes: Decodable {
    var sunrise: String
    var sunset: String
    var day_length: Int
    var solar_noon: String
}


struct LocalizedSunTimes {
    var sunrise: String
    var sunset: String
    var midday: String
    var dayLength: String
}
