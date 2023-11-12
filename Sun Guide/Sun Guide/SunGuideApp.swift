//
//  WidgetTestsApp.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-07-30.
//

import SwiftUI
import LogRocket


@available(iOS 16.0, *)
@main
struct WidgetTestsApp: App {
    var network = Network()
    var locationManager = LocationManager()

    @State private var showCredits: Bool = false

    init() {
        SDK.initialize(configuration: Configuration(appID: "vzsppu/sunguide"))
        SDK.identify(userID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(showModal: $showCredits)
                    .blur(radius: (showCredits ? 10 : 0))
                    .environmentObject(network)
                    .environmentObject(locationManager)
                if showCredits {
                    CreditsView(showModal: $showCredits)
                }
            }
                
        }
    }
}
