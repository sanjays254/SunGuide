//
//  CreditsView.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-12-16.
//

import SwiftUI

struct CreditsView: View {
    @Binding var showModal: Bool

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        showModal.toggle()
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(.trailing)
                    }
                    Spacer()
                }
            }
            VStack {
                Image(systemName: "sun.haze")
                    .foregroundColor(.white)
                    .font(.system(size: 45))
                Text("Thanks to the [Sunrise Sunset API](https://sunrise-sunset.org/api) for their sun data.")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.all)
                Text("Also...check out our Lock Screen widget!")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Text("(Long press on your Lock Screen to add it)")
                    .foregroundColor(Color(UIColor(white: 1, alpha: 0.8)))
                    .italic()
                    .font(.caption)
                Image("accessoryCircular")
                    .font(.system(size: 45))
                    .cornerRadius(10)
                    .padding(.all)
                


                Text("© Shah Labs")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.horizontal)

                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            .contentShape(
                Rectangle()
                
            )
            .onTapGesture {
                self.showModal.toggle()
            }
            
        }

    }
}

struct CreditsView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreditsView_PreviewContainer()
    }
}


struct CreditsView_PreviewContainer: View {
    @State private var showCredits: Bool = false
    var body: some View {
        CreditsView(showModal: $showCredits)
            .background(Color.orange)
    }
}
