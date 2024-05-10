//
//  NavigationBar.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI

struct NavigationBar: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor(red: 79/255, green: 165/255, blue: 88/255, alpha: 1.0)
    }
    
    var body: some View {
        ZStack{
            Color.init(red: 79/255, green: 165/255, blue: 88/255)
            Spacer()
            TabView {
                ContentView(dailyDataModel: DailyDataModel())
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                StatView(dailyDataModel: DailyDataModel())
                    .tabItem {
                        Label("Stat", systemImage: "chart.bar.fill")
                    }
            }
            .accentColor(Color(red: 35/255, green: 35/255, blue: 35/255))
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(red: 79/255, green: 165/255, blue: 88/255, alpha: 1.0)
                
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)]
                appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)]
                appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)]
                
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
                appearance.inlineLayoutAppearance.normal.iconColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
                appearance.compactInlineLayoutAppearance.normal.iconColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct NavigationBarPreviews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
            .environmentObject(DailyDataModel())
    }
}
