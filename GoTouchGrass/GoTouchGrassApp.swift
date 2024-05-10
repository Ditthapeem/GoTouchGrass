//
//  GoTouchGrassApp.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 25/3/2567 BE.
//

import SwiftUI

@main
struct GoTouchGrassApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                NavigationBar()
                    .environmentObject(DailyDataModel()) // Pass in any required environment objects
            }
        }
    }
}
