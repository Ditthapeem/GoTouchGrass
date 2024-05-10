//
//  CustomStatBox.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 2/4/2567 BE.
//

import SwiftUI

struct CustomStatBox<Content: View>: View {
    let stat: String
    let content: Content
    
    init(stat: String, @ViewBuilder content: @escaping () -> Content) {
            self.stat = stat
            self.content = content()
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 234/255, green: 238/255, blue: 212/255)) // EAEED4 color
                    .frame(width: 183, height: 104)
                if(stat == "Calories"){
                    VStack(alignment: .leading){
                        Image(systemName: "flame.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 30)
                        
                        content
                        
                        Text("Calories")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 12))
                        // Query Cal
                    }
                    .padding(.leading, -70)
                } else if (stat == "Sleep"){
                    VStack(alignment: .leading){
                        Image(systemName: "moon.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                        content
                        Text("Sleeping")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 12))
                        // Query Hrs
                    }
                    .padding(.leading, -70)
                } else if (stat == "totalTime"){
                    VStack(alignment: .leading){
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                        content
                        Text("Time")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 12))
                        // Query Timer
                    }
                    .padding(.leading, -70)
                } else if (stat == "AvgCalories"){
                    VStack(alignment: .leading){
                        Image(systemName: "chart.line.uptrend.xyaxis.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                        content
                        Text("Average Calories Per Day")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 12))
                        // Query AvgCalories
                    }
                    .padding(.leading, -10)
                }
            }
        }
    }
}

#Preview {
    CustomStatBox(stat: "Your Stat") {
        // Add any components you want inside the box here
        Text("Your content here")
    }
}
