//
//  PlantCareApp.swift
//  PlantCare
//
//  Created by Admin  on 24/04/2023.
//

import SwiftUI
import UserNotifications

@main
struct PlantCareApp: App {
    
    @StateObject private var manager: DataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(selectedItem: Reminder.init())
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
