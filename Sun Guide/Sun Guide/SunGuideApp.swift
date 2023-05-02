//
//  WidgetTestsApp.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-07-30.
//

import SwiftUI
import LogRocket
import lo



@available(iOS 16.0, *)
@main
struct WidgetTestsApp: App {
//    SDK.initialize(configuration: Configuration(appID: "vzsppu/sunguide")
                   
    var network = Network()
    @State private var showCredits: Bool = false

    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(showModal: $showCredits)
                    .blur(radius: (showCredits ? 10 : 0))
                    .environmentObject(network)
                if showCredits {
                    CreditsView(showModal: $showCredits)
                }
            }
                
        }
    }
}
