//
//  AddPlantView.swift
//  PlantCare
//
//  Created by Taimoor  on 24/04/2023.
//

import SwiftUI

struct AddPlantView: View {
    
    private func sendNotification() {
        let yourFireDate = selectedDate
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:
                                                                    "Your notification title", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Your notification body", arguments: nil)
//        content.categoryIdentifier = "Your notification category"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: yourFireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Your notification identifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                //handle error
            } else {
                //notification set up successfully
            }
        })
    }
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedDate : Date = .now
    @State var nickName: String = ""
    @State var typeOfPlant : String = ""
    @State var cutomerNotes: String = ""
    
    var body: some View {
        VStack(alignment: .center,spacing: 30) {
            TextField("Enter Plant Nick Name...", text: $nickName).textFieldStyle(.roundedBorder)
            TextField("Type of Plant", text: $typeOfPlant).textFieldStyle(.roundedBorder)
            TextField("Add Notes", text: $cutomerNotes) .textFieldStyle(RoundedBorderTextFieldStyle())
            DatePicker("Reminder Date/Time",selection: $selectedDate, displayedComponents: [.date,.hourAndMinute])
            Button("Save Reminder") {
                let newTask = Reminder(context: viewContext)
                newTask.name = nickName
                newTask.type = typeOfPlant
                newTask.note = cutomerNotes
                newTask.date = selectedDate
                try? viewContext.save()
                sendNotification()
                
            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
        }.padding(20)
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}
