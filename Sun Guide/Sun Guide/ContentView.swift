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
    
    @ObservedObject var weatherKitManager = WeatherKitManager()

    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var network: Network

    @Environment(\.scenePhase) var scenePhase
    
    
    @StateObject private var calculator = SunlightLeftCalculator()
    @StateObject private var backgroundGradient = BackgroundGradientCalculator()
    
    
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                            FormattedTimeLabel(time: weatherKitManager.localizedSunTimes?.midday)
                        }
                        .padding(20)
                        HStack {
                            VStack(alignment: .leading) {
                                Image(systemName: "sun.and.horizon")
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                
                                Text("Sunrise")
                                    .foregroundColor(.white)
                                FormattedTimeLabel(time: weatherKitManager.localizedSunTimes?.sunrise)
                            }
                            .padding(20)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Image(systemName: "sun.and.horizon")
                                    .foregroundColor(.white)
                                    .font(.system(size: 35))
                                Text("Sunset")
                                    .foregroundColor(.white)
                                FormattedTimeLabel(time: weatherKitManager.localizedSunTimes?.sunset)
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
                            
                            if (weatherKitManager.localizedSunTimes != nil) {
                                Text(weatherKitManager.localizedSunTimes!.dayLength)
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
                        
                        
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 100, trailing: 20))
                        
                        
                        Spacer()
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text("Today")
                                    .font(.title).bold().foregroundStyle(Color.white)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                
                                Text(Date().formatted(date: .long, time: .omitted))
                                    .foregroundStyle(Color.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                
                                Image(systemName: "location.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                
                                if let city = network.city {
                                    Text(city)
                                        .foregroundStyle(Color.white)
                                } else {
                                    Text("City name")
                                        .foregroundStyle(Color.white)
                                        .redacted(reason: .placeholder)
                                }
                            }
                            
                        }
                    
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        
                    }
                }
            }
            
        }

        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .red]),
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
            
        }
        //        .animation(.easeInOut, value: animate) // not working
        
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
//                network.getTimes()
                //                 backgroundGradient.calculate()
                //                 timer.upstream.connect()
                startTimer()
            } else if newPhase == .inactive {
                stopTimer()
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
            
            await weatherKitManager.getWeather()

        }
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
