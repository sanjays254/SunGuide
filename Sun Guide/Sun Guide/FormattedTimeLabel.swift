//
//  FormattedTimeLabel.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-12-15.
//

import SwiftUI

struct FormattedTimeLabel: View {
    var time: String?
    
    let dateFormatter = ISO8601DateFormatter()


    var body: some View {
        if ((time) != nil) {
            Text(
                dateFormatter.date(
                    from: time!
                )?.formatted(date: .omitted, time: .shortened).lowercased() ?? "7.30pm")
            
            .foregroundColor(.white)
            .font(.title)
            
        } else {
            Text("holder")
                .foregroundColor(.white)
                .font(.title)
                .redacted(reason: .placeholder)
        }
    }
}

struct FormattedTimeLabel_Previews: PreviewProvider {
    static var previews: some View {
        FormattedTimeLabel()
    }
}
