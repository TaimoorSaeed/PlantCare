//
//  ReminderItem.swift
//  PlantCare
//
//  Created by Taimoor  on 03/05/2023.
//

import UIKit
import SwiftUI

/// A simple model to keep track of tasks
class ReminderItem: NSObject, ObservableObject, Identifiable {
    
    var name: String
    var type: String
    var note : String
    var date: Date
    
    @Published var isCompleted: Bool = false
    
    init(name: String, type: String, note: String, date: Date) {
        self.name = name
        self.type = type
        self.note = note
        self.date = date
        
    }
}

