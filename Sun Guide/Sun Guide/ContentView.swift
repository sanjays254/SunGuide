//
//  ContentView.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-07-30.
//

import SwiftUI
import CoreLocation

@available(iOS 16.0, *)
struct ContentView: View {
    @EnvironmentObject var network: Network
    @Environment(\.scenePhase) var scenePhase

    
    
    @StateObject private var calculator = SunlightLeftCalculator()
    @StateObject private var backgroundGradient = BackgroundGradientCalculator()
    
    @State private var animate = false


    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let dateFormatter = ISO8601DateFormatter()
        
    @Binding var showModal: Bool

    var body: some View {
                HStack {
                    ScrollView {
                        ZStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        showModal.toggle()
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                            .padding(.trailing)
                                    }
                                    Spacer()
                                }
                            }
                            VStack {
                                HStack {
                                    Path { path in
                                        // height of arc should be dynamic, based on azimuth
                                        path.addArc(
                                            center: CGPoint(x: 195, y: 200),
                                            radius: CGFloat(140),
                                            startAngle: Angle(degrees: -20),
                                            endAngle: Angle(degrees: -80),
                                            clockwise: true
                                        )
                                    }
                                    .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .bevel, dash: [CGFloat(25)]))
                                    
                                    Path { path in
                                        // height of arc should be dynamic, based on azimuth
                                        
                                        path.addArc(
                                            center: CGPoint(x: 0, y: 200),
                                            radius: CGFloat(140),
                                            startAngle: Angle(degrees: -110),
                                            endAngle: Angle(degrees: -170),
                                            clockwise: true
                                        )
                                        
                                    }
                                    .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .bevel, dash: [CGFloat(25)]))
                                }
                                
                                
                                
                                VStack(alignment: .center) {
                                    Image(systemName: "sun.max")
                                        .foregroundColor(.white)
                                        .font(.system(size: 35))
                                    
                                    Text("Midday")
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                    FormattedTimeLabel(time: network.localizedSunTimes?.midday)
                                }
                                .padding(20)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Image(systemName: "sun.and.horizon")
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                        
                                        Text("Sunrise")
                                            .foregroundColor(.white)
                                        FormattedTimeLabel(time: network.localizedSunTimes?.sunrise)
                                    }
                                    .padding(20)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Image(systemName: "sun.and.horizon")
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                        Text("Sunset")
                                            .foregroundColor(.white)
                                        FormattedTimeLabel(time: network.localizedSunTimes?.sunset)
                                    }
                                    .padding(20)
                                    
                                    .cornerRadius(10)
                                    
                                }
                                
                                Path { path in
                                    // height of arc should be dynamic, based on azimuth
                                    path.addLine(to: CGPoint(x: 0, y: 200))
                                }
                                .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .bevel, dash: [CGFloat(25)]))
                                

                                    
                                VStack(alignment: .leading) {
                                    Divider()
                                        .overlay(Color.white)

                                    
                                    Text("Total sunlight")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()

                                    if (network.localizedSunTimes != nil) {
                                        Text(network.localizedSunTimes!.dayLength)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    } else {
                                        Text("3h 45m 67s")
                                            .foregroundColor(.white)
                                            .font(.title3)

                                            .redacted(reason: .placeholder)
                                        
                                    }
                                    
                                    
                                    Divider()
                                        .overlay(Color.white)

                                    Spacer()
                                    
                                        Text("Sunlight remaining")
                                            .foregroundColor(.white)
                                            .font(.caption)

                                    Spacer()

                                    if (calculator.countdown != nil) {
                                        Text("\(calculator.countdown!)")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                    } else {
                                        Text("3h 45m 67s")
                                            .foregroundColor(.white)
                                            .font(.title3)

                                            .redacted(reason: .placeholder)
                                    }

                                    
                                    Divider()
                                        .overlay(Color.white)
                                        
                                    
                                }
                                
                                
                                .padding(EdgeInsets(top: 30, leading: 20, bottom: 50, trailing: 20))
                                
                                
                                Spacer(minLength: 100)
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                    
                                        
                                        Text("Today")
                                        
                                            .font(.title).bold().foregroundStyle(Color.white)
                                        
                                        Spacer(minLength: 5)

                                        Text(Date().formatted(date: .long, time: .omitted))
                                        .foregroundStyle(Color.white)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                      
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        
                                        Image(systemName: "location.circle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                        Spacer(minLength: 5)
                                        
                                        if (network.city != nil) {
                                            Text(network.city!)
                                                .foregroundStyle(Color.white)
                                        } else {
                                            Text("City name")
                                                .foregroundStyle(Color.white)
                                                .redacted(reason: .placeholder)
                                        }

                                        
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        gradient: animate ? Gradient(colors: [backgroundGradient.topColor, backgroundGradient.bottomColor]) : Gradient(colors: [.yellow, .red]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(0.9)
                .scrollIndicators(.never)

            
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            calculator.updateCountdown()
            backgroundGradient.calculate()
            animate = true

        }
        .animation(.easeInOut, value: animate) // not working

        .onChange(of: scenePhase) { newPhase in
             if newPhase == .active {
                 network.getTimes()
                 backgroundGradient.calculate()
                 animate = true
//                 timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
             } else if newPhase == .inactive {
                 timer.upstream.connect().cancel()
             } else if newPhase == .background {
                 print("Background")
             }
         }
        
        .task(id: network.sunTimes?.sunset) {
            if let sunsetTime = network.sunTimes?.sunset {
                calculator.setSunsetTime(sunsetTime: sunsetTime)
                backgroundGradient.setSunsetTime(sunsetTime: sunsetTime)

            }
            
            if let sunriseTime = network.sunTimes?.sunrise {
                calculator.setSunriseTime(sunriseTime: sunriseTime)
                backgroundGradient.setSunriseTime(sunriseTime: sunriseTime)

            }
        }
    }
    


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_PreviewContainer()
    }
}


struct ContentView_PreviewContainer: View {
    @State private var showCredits: Bool = false
    var body: some View {
        ContentView(showModal: $showCredits)
            .environmentObject(Network())
    }
}
