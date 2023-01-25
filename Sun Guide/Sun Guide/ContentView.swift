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
                                        
                                        Text("Sunset")
                                            .foregroundColor(.white)
                                        FormattedTimeLabel(time: network.localizedSunTimes?.sunset)
                                    }
                                    .padding(20)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Image(systemName: "sun.and.horizon")
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                        Text("Sunrise")
                                            .foregroundColor(.white)
                                        FormattedTimeLabel(time: network.localizedSunTimes?.sunrise)
                                    }
                                    .padding(20)
                                    
                                    .cornerRadius(10)
                                    
                                }
                                
                                Path { path in
                                    // height of arc should be dynamic, based on azimuth
                                    path.addLine(to: CGPoint(x: 0, y: 200))
                                }
                                .stroke(.white, style: StrokeStyle(lineWidth: 2, lineCap: .square, lineJoin: .bevel, dash: [CGFloat(25)]))
                                
                                HStack {
                                    
                                    
                                    VStack(alignment: .leading) {
                                        Text("Day length")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                        if (network.localizedSunTimes != nil) {
                                            Text(network.localizedSunTimes!.dayLength)
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        } else {
                                            Text("Day length")
                                                .foregroundColor(.white)
                                            .redacted(reason: .placeholder)

                                        }


                                    }
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("Sunlight left today")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                        Text("6h 5m 57s")
                                            .foregroundColor(.white)
                                            .font(.caption)

                                    }
                                    
                                }
                                .padding(.horizontal)
                                
                                Spacer(minLength: 100)
                                HStack {
                                    VStack(alignment: .leading) {
                                       
                                            Image(systemName: "location.circle")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                            Text(network.city ?? "Waiting")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundStyle(Color.white)
                                        
                                        Spacer(minLength: 20)
                                        
                                        Text("Today")
                                        
                                            .font(.title).bold().foregroundStyle(Color.white)
                                        Text(dateFormatter.date(
                                            from:network.localizedSunTimes?.sunset ?? "Dunno")?.formatted(date: .long, time: .omitted) ?? "Today")
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                    }
                                    .padding(50)
                                    Spacer()
                                }
                            }
                            
                            Spacer()
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
                .opacity(0.8)
                .scrollIndicators(.never)
            
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("temp")
//        ContentView(showModal: false)
//            .environmentObject(Network())
    }
}
